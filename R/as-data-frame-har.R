#' Turns a "HAR"-like object into a data frame(tibble)
#'
#' @md
#' @param harentry_obj A `harentry` object
#' @return data frame (tibble)
#' @export
as_data_frame.harentry <- function(harentry_obj) {

  req <- harentry_obj$request
  resp <- harentry_obj$response

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

#' @md
#' @param harentries_obj A `harentry` object
#' @rdname as_data_frame.harentry
#' @export
as_data_frame.harentries <- function(harentries_obj) {
  map_df(harentries_obj, as_data_frame)
}

#' @md
#' @param har_obj A `har` object
#' @rdname as_data_frame.harentry
#' @export
as_data_frame.har <- function(har_obj) {
  as_data_frame(har_obj$log$entries)
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

