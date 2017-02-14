#' Retrieve or test content type of a HAR request object
#'
#' @param har_resp_obj HAR response object
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
is_html <- function(har_resp_obj) {  is_content_type(har_resp_obj, type="text/html") }

#' @rdname get_content_type
#' @export
is_jpeg <- function(har_resp_obj) {  is_content_type(har_resp_obj, type="image/jpeg") }

#' @rdname get_content_type
#' @export
is_png <- function(har_resp_obj) {  is_content_type(har_resp_obj, type="image/png") }

#' @rdname get_content_type
#' @export
is_svg <- function(har_resp_obj) {  is_content_type(har_resp_obj, type="image/svg+xml") }

#' @rdname get_content_type
#' @export
is_gif <- function(har_resp_obj) {  is_content_type(har_resp_obj, type="image/gif") }

#' Retrieve size of content |  body | headers
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

