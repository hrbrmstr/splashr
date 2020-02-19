.tidy_one_entry <- function(x, include_content = TRUE) {

  .x <- x

  if (length(.x[["timings"]])) {
    data.frame(
      stage = names(.x[["timings"]]),
      value = unlist(.x[["timings"]], use.names = FALSE),
      stringsAsFactors = FALSE
    ) -> timings
  } else {
    timings <- data.frame(stringsAsFactors = FALSE)
  }
  class(timings) <- c("tbl_df", "tbl", "data.frame")


  if (length(.x[["request"]][["headers"]])) {
    data.frame(
      name =vapply(.x[["request"]][["headers"]], `[[`, character(1), "name", USE.NAMES = FALSE),
      value = vapply(.x[["request"]][["headers"]], `[[`, character(1), "value", USE.NAMES = FALSE),
      stringsAsFactors = FALSE
    ) -> req_headers
  } else {
    req_headers <- data.frame(stringsAsFactors = FALSE)
  }
  class(req_headers) <- c("tbl_df", "tbl", "data.frame")

  if (length(.x[["response"]][["headers"]])) {
    data.frame(
      name =vapply(.x[["response"]][["headers"]], `[[`, character(1), "name", USE.NAMES = FALSE),
      value = vapply(.x[["response"]][["headers"]], `[[`, character(1), "value", USE.NAMES = FALSE),
      stringsAsFactors = FALSE
    ) -> headers
  } else {
    headers <- data.frame(stringsAsFactors = FALSE)
  }
  class(headers) <- c("tbl_df", "tbl", "data.frame")

  if (length(.x[["request"]][["cookies"]])) {
    data.frame(
      name =vapply(.x[["request"]][["cookies"]], `[[`, character(1), "name", USE.NAMES = FALSE),
      value = vapply(.x[["request"]][["cookies"]], `[[`, character(1), "value", USE.NAMES = FALSE),
      stringsAsFactors = FALSE
    ) -> req_cookies
  } else {
    req_cookies <- data.frame(stringsAsFactors = FALSE)
  }
  class(req_cookies) <- c("tbl_df", "tbl", "data.frame")

  if (length(.x[["response"]][["cookies"]])) {
    data.frame(
      name =vapply(.x[["response"]][["cookies"]], `[[`, character(1), "name", USE.NAMES = FALSE),
      value = vapply(.x[["response"]][["cookies"]], `[[`, character(1), "value", USE.NAMES = FALSE),
      stringsAsFactors = FALSE
    ) -> res_cookies
  } else {
    res_cookies <- data.frame(stringsAsFactors = FALSE)
  }
  class(res_cookies) <- c("tbl_df", "tbl", "data.frame")

  data.frame(
    status = .x[["response"]][["status"]] %l0% NA_character_,
    started = .x[["startedDateTime"]] %l0% NA_character_,
    total_time = .x[["time"]] %l0% NA_integer_,
    page_ref = .x[["pageref"]] %l0% NA_character_,
    timings = I(list(timings)),
    req_url = .x[["request"]][["url"]] %l0% NA_character_,
    req_method = .x[["request"]][["method"]] %l0% NA_character_,
    req_http_version = .x[["request"]][["httpVersion"]] %l0% NA_character_,
    req_hdr_size = .x[["request"]][["headersSize"]] %l0% NA_character_,
    req_headers = I(list(req_headers)),
    req_cookies = I(list(req_cookies)),
    resp_url = .x[["response"]][["url"]] %l0% NA_character_,
    resp_rdrurl = .x[["response"]][["redirectURL"]] %l0% NA_character_,
    resp_type = .x[["response"]][["content"]][["mimeType"]] %l0% NA_character_,
    resp_size = .x[["resonse"]][["bodySize"]] %l0% NA_integer_,
    resp_cookies = I(list(res_cookies)),
    resp_headers = I(list(headers)),
    resp_encoding = .x[["resonse"]][["content"]][["encoding"]] %l0% NA_character_,
    resp_content_size = as.numeric(.x[["response"]][["content"]][["size"]]) %l0% NA_real_,
    stringsAsFactors = FALSE
  ) -> out

  if (include_content) out$resp_content <- .x[["response"]][["content"]][["text"]] %l0% NA_character_

  class(out) <- c("tbl_df", "tbl", "data.frame")

  out

}

#' Turn a gnHARly HAR object into a tidy data frame (tibble)
#'
#' @md
#' @param x A `harentry` object
#' @param include_content if `TRUE` (the default) the encoded element content will be returned in the data frame
#' @return data frame (tibble)
#' @export
tidy_har <- function(.x, include_content = TRUE) {

  if (inherits(.x, "har")) {
    out <- tidy_har(.x[["log"]][["entries"]], include_content = include_content)
  } else if (inherits(.x, "harlog")) {
    out <- tidy_har(.x[["entries"]], include_content = include_content)
  } else if (inherits(.x, "harentries")) {
    out <- do.call(rbind.data.frame, lapply(.x, .tidy_one_entry, include_content = include_content))
    class(out) <- c("tbl_df", "tbl", "data.frame")
  } else if (inherits(.x, "harentry")) {
    out <- .tidy_one_entry(.x, include_content = include_content)
  } else {
    stopifnot(inherits(.x, "harentries"))
  }

  out

}
