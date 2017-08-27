#' Create an httr verb request function from an HAR request
#'
#' This function is very useful if you used `splashr` to find XHR requests in a dynamic
#' page and want to be able to make a call directly to that XHR resource. Once you
#' identify the proper HAR entry, pass it to this function and fully working function
#' that makes an `httr::VERB()` request will be created and returned. The text of the function
#' will also be put onto the clipboad if `add_clip` is `TRUE``
#'
#' @md
#' @param entry HAR entry
#' @param quiet quiet (no messages)
#' @param add_clip add clip (paste the function text to the clipboard)
#' @export
as_httr_req <- function(entry, quiet=TRUE, add_clip=TRUE) {

  req <- entry$request

  req$headers <- purrr::map(req$headers, "value") %>%
    setNames(map_chr(req$headers, "name"))

  ml <- getOption("deparse.max.lines")
  options(deparse.max.lines=10000)

  template <- "httr::VERB(verb = '%s', url = '%s' %s%s%s%s%s%s)"

  hdrs <- enc <- bdy <- ckies <- auth <- verbos <- cfg <- ""

  if (length(req$headers) > 0) {

    # try to determine encoding
    ct_idx <- which(grepl("content-type", names(req$headers), ignore.case=TRUE))
    if (length(ct_idx) > 0) {
      # retrieve & delete the content type
      ct <- req$headers[[ct_idx]]
      req$headers[[ct_idx]] <- NULL

      if (stringi::stri_detect_regex(ct, "multipart")) {
        enc <- ", encode = 'multipart'"
      } else if (stringi::stri_detect_regex(ct, "form")) {
        enc <- ", encode = 'form'"
      } else if (stringi::stri_detect_regex(ct, "json")) {
        enc <- ", encode = 'json'"
      } else {
        enc <- ""
      }
    }

    hdrs <- paste0(capture.output(dput(req$headers,  control=NULL)),
                   collapse="")
    hdrs <- sub("^list", ", httr::add_headers", hdrs)

  }

  if (length(req$data) > 0) {
    bdy_bits <- paste0(capture.output(dput(parse_query(req$data), control=NULL)),
                       collapse="")
    bdy <- sprintf(", body = %s", bdy_bits)
  }

  if (length(req$url_parts$username) > 0) {
    auth <- sprintf(", httr::authenticate(user='%s', password='%s')",
                    req$url_parts$username, req$url_parts$password)
  }

  if (length(req$verbose) > 0) {
    verbos <- ", httr::verbose()"
  }

  if (length(req$cookies) > 0) {
    ckies <- paste0(capture.output(dput(req$cookies, control=NULL)),
                    collapse="")
    ckies <- sub("^list", ", httr::set_cookies", ckies)
  }

  REQ_URL <- req$url

  out <- sprintf(template, toupper(req$method), REQ_URL, auth, verbos, hdrs, ckies, bdy, enc)

  # this does a half-decent job formatting the R function text
  fil <- tempfile(fileext=".R")
  on.exit(unlink(fil))
  formatR::tidy_source(text=out, width.cutoff=30, indent=4, file=fil)
  tmp <- paste0(readLines(fil), collapse="\n")

  if (add_clip) clipr::write_clip(tmp)

  if (!quiet) cat(tmp, "\n")

  # make a bona fide R function
  f <- function() {}
  formals(f) <- NULL
  environment(f) <- parent.frame()
  body(f) <- as.expression(parse(text=tmp))

  options(deparse.max.lines=ml)

  return(f)

}
