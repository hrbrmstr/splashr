splash_url <- function(splash_obj) { sprintf("http://%s:%s", splash_obj$host, splash_obj$port) }

#' Configure parameters for connecting to a Splash server
#'
#' @param host host or IP address
#' @param port port the server is running on (default is 8050)
#' @param user,pass leave `NULL` if basic auth is not configured. Otherwise,
#'        fill in what you need for basic authentication.
#' @export
#' @examples \dontrun{
#' sp <- splash()
#' }
splash <- function(host, port=8050L, user=NULL, pass=NULL) {
  list(host=host, port=port, user=user, pass=pass)
}

#' @rdname splash
#' @export
splash_local <- splash("localhost")

s_GET <- purrr::safely(GET)

#' Test if a Splash server is up
#'
#' @md
#' @param splash_obj A splash connection object
#' @family splash_info_functions
#' @return `TRUE` if Slash server is running, otherwise `FALSE`
#' @export
#' @examples \dontrun{
#' sp <- splash()
#' splash_active(sp)
#' }
splash_active <- function(splash_obj = splash_local) {

  if (is.null(splash_obj$user)) {
    res <- s_GET(splash_url(splash_obj), path="_ping")
  } else {
    res <- s_GET(splash_url(splash_obj), path="_ping",
                 httr::authenticate(splash_obj$user, splash_obj$pass))
  }

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
#' @family splash_info_functions
#' @export
#' @examples \dontrun{
#' sp <- splash()
#' splash_version(sp)
#' }
splash_version <- function(splash_obj = splash_local) {
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
#' @family splash_info_functions
#' @export
#' @examples \dontrun{
#' sp <- splash()
#' splash_history(sp)
#' }
splash_history <- function(splash_obj = splash_local) {
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
#' @family splash_info_functions
#' @export
#' @examples \dontrun{
#' sp <- splash()
#' splash_perf_stats(sp)
#' }
splash_perf_stats <- function(splash_obj = splash_local) {
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
#' @family splash_info_functions
#' @export
#' @examples \dontrun{
#' sp <- splash()
#' splash_debug(sp)
#' }
splash_debug <- function(splash_obj = splash_local) {

  if (is.null(splash_obj$user)) {
    httr::GET(splash_url(splash_obj), path="_debug") %>%
      httr::stop_for_status() %>%
      httr::content(as="text", encoding="UTF-8") %>%
      jsonlite::fromJSON() -> out
  } else {
    httr::GET(splash_url(splash_obj), path="_debug",
              httr::authenticate(splash_obj$user, splash_obj$pass)) %>%
      httr::stop_for_status() %>%
      httr::content(as="text", encoding="UTF-8") %>%
      jsonlite::fromJSON() -> out
  }

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
