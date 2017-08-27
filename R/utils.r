#' Convert a Base64 encoded string into an R object
#'
#' A simple wrapper around calls to `openssl::base64_decode()` and
#' `jsonlite::fromJSON()`.
#'
#' @md
#' @param x a string
#' @param flatten flatten JSON structures upon conversion?
#' @param ... passed on to `jsonlite::fromJSON()`
#' @export
json_fromb64 <- function(x, flatten=TRUE, ...) {

  tmp <- openssl::base64_decode(x)
  tmp <- readBin(tmp, "character")
  jsonlite::fromJSON(tmp, flatten=flatten, ...)

}
