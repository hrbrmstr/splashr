splash_url <- function(splash_obj) { sprintf("http://%s:%s", splash_obj$host, splash_obj$port) }

#' Configure parameters for connecting to a Splash server
#'
#' @param host host or IP address
#' @param port port the server is running on (default is 8050)
#' @export
splash <- function(host, port=8050L) {
  list(host=host, port=port)
}

#' Test if a Splash server is up
#'
#' @param splash_obj A splash connection object
#' @export
splash_active <- function(splash_obj) {

  httr::GET(splash_url(splash_obj), path="_ping") %>%
    httr::stop_for_status() %>%
    httr::content(as="text", encoding="UTF-8") %>%
    jsonlite::fromJSON() -> out

  out$url <- splash_url(splash_obj)

  class(out) <- c("splash_status", class(out))

  out

}

#' @rdname splash_active
#' @keywords internal
#' @export
print.splash_status <- function(x, ...) {
  cat(sprintf("Status of splash instance on [%s]: %s. Max RSS: %s\n", x$url, x$status, x$maxrss))
  invisible(x)
}

#' Retrieve debug-level info for a Splash server
#'
#' @param splash_obj A splash connection object
#' @export
splash_debug <- function(splash_obj) {

  httr::GET(splash_url(splash_obj), path="_debug") %>%
    httr::stop_for_status() %>%
    httr::content(as="text", encoding="UTF-8") %>%
    jsonlite::fromJSON() -> out

  out$url <- splash_url(splash_obj)

  class(out) <- c("splash_debug", class(out))

  out

}

#' @rdname splash_debug
#' @keywords internal
#' @export
print.splash_debug <- function(x, ...) {
  print(str(x))
  invisible(x)
}
