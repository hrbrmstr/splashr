#' Retrieve the body content of a HAR entry
#'
#' @md
#' @param har_resp_obj HAR response object
#' @return A `raw` vector of the content or `NULL`
#' @export
get_response_body <- function(har_resp_obj) {
  resp <- har_resp_obj$response$content$text
  if (resp == "") return(NULL)
  openssl::base64_decode(resp)
}

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
is_xhr <- function(x) {

  if (is.null(x$request$headers)) return(NA)
  if (length(x$request$headers)==0) return(NA)

  y <- map(x$request$headers, "value")
  names(y) <- tolower(map_chr(x$request$headers, "name"))

  if ("x-requested-with" %in% names(y)) {
    return(tolower("xmlhttprequest") == tolower(y[["x-requested-with"]]))
  } else {
    return(FALSE)
  }

}

#' Retrieve request URL
#'
#' @param har_resp_obj HAR response object
#' @export
get_request_url <- function(har_resp_obj) {
  utype <- har_resp_obj$request$url
  if (utype == "") return(NA_character_)
  utype
}

#' Retrieve or test request type
#'
#' @param har_resp_obj HAR response object
#' @export
get_request_type <- function(har_resp_obj) {
  rtype <- har_resp_obj$request$method
  if (rtype == "") return(NA_character_)
  rtype
}

#' @rdname get_request_type
#' @export
is_get <- function(har_resp_obj) { get_requet_type(har_resp_obj) == "GET" }

#' @rdname get_request_type
#' @export
is_post <- function(har_resp_obj) { get_requet_type(har_resp_obj) == "POST" }
