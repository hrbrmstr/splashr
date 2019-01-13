#' Turns a "HAR"-like object into a data frame(tibble)
#'
#' @md
#' @param x A `harentry` object
#' @param ... ignored
#' @return data frame (tibble)
#' @export
as_data_frame.harentry <- function(x, ...) {

  req <- x$request
  resp <- x$response

  data_frame(
    request_url = req$url,
    request_method = req$method,
    request_http_version = req$httpVersion,
    request_query_string = list(req$queryString),
    request_header_size = req$headersSize,
    requestheaders = list(if (length(req$headers) > 0) flatten_df(req$headers) else data_frame()),
    requestcookies = list(if (length(req$cookies) > 0) flatten_df(req$cookies) else data_frame()),
    response_url = resp$url,
    response_http_version = resp$httpVersion,
    status_text = resp$statusText,
    status = resp$status,
    ok = resp$ok,
    redirect_url = resp$redirectURL,
    response_headers_size = resp$headersSize,
    response_headers = list(if (length(resp$headers) > 0) flatten_df(resp$headers) else data_frame()),
    response_cookies = list(if (length(resp$cookies) > 0) flatten_df(resp$cookies) else data_frame()),
    response_body_size = resp$bodySize,
    content_type = resp$content$mimeType,
    content_encoding = resp$content$encoding %||% NA_character_,
    content_size = resp$content$size,
    content = resp$content$text %||% NA_character_
  )

}

#' @rdname as_data_frame.harentry
#' @export
as_data_frame.harentries <- function(x, ...) {
  map_df(x, as_data_frame)
}

#' @rdname as_data_frame.harentry
#' @export
as_data_frame.har <- function(x, ...) {
  as_data_frame(x$log$entries)
}

#' @export
#' @rdname as_data_frame.harentry
as.data.frame.har <- as_data_frame.har

#' @export
#' @rdname as_data_frame.harentry
as.data.frame.harentries <- as_data_frame.harentries

#' @export
#' @rdname as_data_frame.harentry
as.data.frame.harentry <- as_data_frame.harentry

