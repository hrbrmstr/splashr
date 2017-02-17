splash_url <- function(splash_obj) { sprintf("http://%s:%s", splash_obj$host, splash_obj$port) }

#' Configure parameters for connecting to a Splash server
#'
#' @param host host or IP address
#' @param port port the server is running on (default is 8050)
#' @export
splash <- function(host, port=8050L) {
  list(host=host, port=port)
}

#' @rdname splash
#' @export
splash_local <- splash("localhost")

s_GET <- purrr::safely(GET)

#' Test if a Splash server is up
#'
#' @md
#' @param splash_obj A splash connection object
#' @return `TRUE` if Slash server is running, otherwise `FALSE`
#' @export
splash_active <- function(splash_obj) {

  res <- s_GET(splash_url(splash_obj), path="_ping")

  if (is.null(res$result)) return(FALSE)
  if (httr::status_code(res$result) >=300) return(FALSE)

  httr::content(res$result, as="text", encoding="UTF-8") %>%
    jsonlite::fromJSON() -> out

  out$url <- splash_url(splash_obj)

  message(sprintf("Status of splash instance on [%s]: %s. Max RSS: %s Mb\n",
                  out$url, out$status, scales::comma(out$maxrss/1024/1024)))

  if ("status" %in% names(out)) return(out$status == "ok")

  return(FALSE)

}

#' Get Splash version information
#'
#' @param splash_obj A splash connection object
#' @export
splash_version <- function(splash_obj) {
  execute_lua(splash_obj, '
function main(splash)
  return splash:get_version()
end
') -> res
  jsonlite::fromJSON(rawToChar(res))
}

#' Get information about requests/responses for the pages loaded
#'
#' @param splash_obj A splash connection object
#' @export
splash_history <- function(splash_obj) {
  execute_lua(splash_obj, '
function main(splash)
  return splash:history()
end
') -> res
  jsonlite::fromJSON(rawToChar(res))
}


#' Get Splash performance-related statistics
#'
#' @param splash_obj A splash connection object
#' @export
splash_perf_stats <- function(splash_obj) {
  execute_lua(splash_obj, '
function main(splash)
  return splash:get_perf_stats()
end
') -> res
  jsonlite::fromJSON(rawToChar(res))
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
