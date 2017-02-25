#' Retrieve size of content | body | headers
#'
#' @param har_resp_obj HAR response object
#' @export
get_content_size <- function(har_resp_obj) {
  csize <- har_resp_obj$response$content$size
  if (is.null(csize)) return(NA_real_)
  return(as.numeric(csize))
}

#' @rdname get_content_size
#' @export
get_body_size <- function(har_resp_obj) {
  bsize <- har_resp_obj$response$bodySize
  if (is.null(bsize)) return(NA_real_)
  return(as.numeric(bsize))
}

#' @rdname get_content_size
#' @export
get_headers_size <- function(har_resp_obj) {
  hsize <- har_resp_obj$response$headersSize
  if (is.null(hsize)) return(NA_real_)
  return(as.numeric(hsize))
}

