#' Execute a custom rendering script and return a result.
#'
#' @md
#' @param splash_obj Object created by a call to [splash()]
#' @param lua_source Browser automation script. See [Splash Script](http://splash.readthedocs.io/en/stable/scripting-tutorial.html#scripting-tutorial) Tutorial for more info.
#' @param timeout A timeout (in seconds) for the render (defaults to 30). Without
#'        reconfiguring the startup parameters of the Splash server (not this package)
#'        the maximum allowed value for the timeout is 60 seconds.
#' @param allowed_domains Comma-separated list of allowed domain names. If present, Splash
#'        won’t load anything neither from domains not in this list nor from subdomains of
#'        domains not in this list.
#' @param proxy Proxy profile name or proxy URL.
#' @param filters Comma-separated list of request filter names.
#' @param save_args A list of argument names to put in cache.
#' @param load_args Parameter values to load from cache
#' @return `raw` content from the `httr` call. Given the vast diversity of possible return
#'         values, it's up to the caller to handle the return value.
#' @family splash_renderers
#' @export
#' @examples \dontrun{
#' splash_local %>%
#'   execute_lua('
#' function main(splash)
#'   splash:go("https://projects.fivethirtyeight.com/congress-trump-score/")
#'   splash:wait(0.5)
#'   return splash:evaljs("memberScores")
#' end
#' ') -> res
#'
#' rawToChar(res) %>%
#'   jsonlite::fromJSON(flatten=TRUE) %>%
#'   purrr::map(tibble::as_tibble) -> member_scores
#'
#' member_scores
#' }
execute_lua <- function(splash_obj, lua_source, timeout=30, allowed_domains,
                        proxy, filters, save_args, load_args) {

  params <- list(lua_source=lua_source, timeout=timeout)

  if (!missing(allowed_domains)) params$allowed_domains <- allowed_domains
  if (!missing(proxy)) params$proxy <- proxy
  if (!missing(filters)) params$filters <- filters
  if (!missing(save_args)) params$save_args <- save_args
  if (!missing(load_args)) params$load_args <- load_args

  res <- httr::GET(splash_url(splash_obj), path="execute", encode="json", query=params)

  httr::stop_for_status(res)

  out <- httr::content(res, as="raw")

  out

}