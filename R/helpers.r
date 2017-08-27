#' Retrieve the body content of a HAR entry
#'
#' @md
#' @param har_resp_obj HAR response object
#' @param type return type. If `raw` (default) then a raw vector of the content is returned.
#'     If `text` then a character vector.
#' @family splash_har_helpers
#' @return A `raw` vector of the content or `NULL` or a `character` if `type` == `text`
#' @export
get_response_body <- function(har_resp_obj, type=c("raw", "text")) {
  type <- match.arg(type, c("raw", "text"))
  resp <- har_resp_obj$response$content$text
  if (resp == "") return(NULL)
  tmp <- openssl::base64_decode(resp)
  if (type == "text") tmp <- readBin(tmp, "character")
  tmp
}

#' Retrieve or test content type of a HAR request object
#'
#' @param har_resp_obj a reponse object from [render_har()] or [execute_lua()]
#' @family splash_har_helpers
#' @export
get_content_type <- function(har_resp_obj) {
  ctype <- har_resp_obj$response$content$mimeType
  if (ctype == "") return(NA_character_)
  if (any(grepl(";", ctype))) ctype <- gsub(";.*$", "", ctype)
  ctype
}

#' @md
#' @rdname get_content_type
#' @param type content type to compare to (default: "`application/json`")
#' @export
is_content_type <- function(har_resp_obj, type="application/json") {
  get_content_type(har_resp_obj) == type
}

#' @rdname get_content_type
#' @export
is_json <- function(har_resp_obj) { is_content_type(har_resp_obj) }

#' @rdname get_content_type
#' @export
is_xml <- function(har_resp_obj) {  is_content_type(har_resp_obj, type="application/xml") }

#' @rdname get_content_type
#' @export
is_css <- function(har_resp_obj) {  is_content_type(har_resp_obj, type="text/css") }

#' @rdname get_content_type
#' @export
is_plain <- function(har_resp_obj) {  is_content_type(har_resp_obj, type="text/plain") }

#' @rdname get_content_type
#' @export
is_binary <- function(har_resp_obj) {  is_content_type(har_resp_obj, type="application/octet-stream") }

#' @rdname get_content_type
#' @export
is_javascript <- function(har_resp_obj) {
  is_content_type(har_resp_obj, type="text/javascript") |
    is_content_type(har_resp_obj, type="text/x-javascript")
}

#' @rdname get_content_type
#' @export
is_html <- function(har_resp_obj) { is_content_type(har_resp_obj, type="text/html") }

#' @rdname get_content_type
#' @export
is_jpeg <- function(har_resp_obj) { is_content_type(har_resp_obj, type="image/jpeg") }

#' @rdname get_content_type
#' @export
is_png <- function(har_resp_obj) { is_content_type(har_resp_obj, type="image/png") }

#' @rdname get_content_type
#' @export
is_svg <- function(har_resp_obj) { is_content_type(har_resp_obj, type="image/svg+xml") }

#' @rdname get_content_type
#' @export
is_gif <- function(har_resp_obj) { is_content_type(har_resp_obj, type="image/gif") }

#' @rdname get_content_type
#' @export
is_xhr <- function(har_resp_obj) {

  if (is.null(har_resp_obj$request$headers)) return(NA)
  if (length(har_resp_obj$request$headers)==0) return(NA)

  y <- map(har_resp_obj$request$headers, "value")
  names(y) <- tolower(map_chr(har_resp_obj$request$headers, "name"))

  if ("x-requested-with" %in% names(y)) {
    return(tolower("xmlhttprequest") == tolower(y[["x-requested-with"]]))
  } else {
    return(FALSE)
  }

}

#' Retrieve request URL
#'
#' @param har_resp_obj HAR response object
#' @family splash_har_helpers
#' @export
get_request_url <- function(har_resp_obj) {
  utype <- har_resp_obj$request$url
  if (utype == "") return(NA_character_)
  utype
}

#' Retrieve or test request type
#'
#' @param har_resp_obj HAR response object
#' @family splash_har_helpers
#' @export
get_request_type <- function(har_resp_obj) {
  rtype <- har_resp_obj$request$method
  if (rtype == "") return(NA_character_)
  rtype
}

#' @rdname get_request_type
#' @export
is_get <- function(har_resp_obj) { get_request_type(har_resp_obj) == "GET" }

#' @rdname get_request_type
#' @export
is_post <- function(har_resp_obj) { get_request_type(har_resp_obj) == "POST" }

#' Retrieve just the HAR entries from a splashr request
#'
#' @param x can be a `har` object, `harlog` object or `harentries` object
#' @export
har_entries <- function(x) {
  if (inherits(x, "har")) {
    x$log$entries
  } else if (inherits(x, "harlog")) {
    x$entries
  } else if (inherits(x, "harentries")) {
    x
  } else {
    NULL
  }
}

#' Retrieve an entry by index from a HAR object
#'
#' @param x can be a `har` object, `harlog` object or `harentries` object
#' @param i index of the HAR entry to retrieve
#' @family splash_har_helpers
#' @export
get_har_entry <- function(x, i=1) {
  if (inherits(x, "har")) {
    x$log$entries[[i]]
  } else if (inherits(x, "harlog")) {
    x$entries[[i]]
  } else if (inherits(x, "harentries")) {
    x[[i]]
  } else {
    NULL
  }
}

#' Retrieves number of HAR entries in a response
#'
#' @param x can be a `har` object, `harlog` object or `harentries` object
#' @family splash_har_helpers
#' @export
har_entry_count <- function(x) {
  if (inherits(x, "har")) {
    length(x$log$entries)
  } else if (inherits(x, "harlog")) {
    length(x$entries)
  } else if (inherits(x, "harentries")) {
    length(x)
  } else {
    NULL
  }
}
