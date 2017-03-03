#' Return information about Splash interaction with a website in HAR format.
#'
#' It includes information about requests made, responses received, timings, headers, etc and
#' is incredibly detailed, full of information on every component loaded.
#'
#' @md
#' @param response_body When `TRUE`, response content is included in the HAR records
#' @inheritParams render_html
#' @return a [HARtools] `har` object
#' @references [Splash docs](http://splash.readthedocs.io/en/stable/index.html)
#' @export
render_har <- function(splash_obj = splash_local, url, base_url, response_body=FALSE, timeout=30, resource_timeout, wait=0,
                       proxy, js, js_src, filters, allowed_domains, allowed_content_types,
                       forbidden_content_types, viewport="1024x768", images, headers, body,
                       http_method, save_args, load_args) {

  wait <- check_wait(wait)

  params <- list(url=url, timeout=timeout, wait=wait, viewport=jsonlite::unbox(viewport),
                 response_body=as.numeric(response_body))

  if (!missing(base_url)) params$base_url <- jsonlite::unbox(base_url)
  if (!missing(resource_timeout)) params$resource_timeout <- resource_timeout
  if (!missing(proxy)) params$proxy <- jsonlite::unbox(proxy)
  if (!missing(js)) params$js <- jsonlite::unbox(js)
  if (!missing(js_src)) params$js_src <- jsonlite::unbox(js_src)
  if (!missing(filters)) params$filters <- jsonlite::unbox(filters)
  if (!missing(allowed_domains)) params$allowed_domains <- jsonlite::unbox(allowed_domains)
  if (!missing(allowed_content_types)) params$allowed_content_types <- jsonlite::unbox(allowed_content_types)
  if (!missing(forbidden_content_types)) params$forbidden_content_types <- jsonlite::unbox(forbidden_content_types)
  if (!missing(images)) params$images <- as.numeric(images)
  if (!missing(headers)) params$headers <- headers
  if (!missing(body)) params$body <- jsonlite::unbox(body)
  if (!missing(http_method)) params$http_method <- jsonlite::unbox(http_method)
  if (!missing(save_args)) params$save_args <- jsonlite::unbox(save_args)
  if (!missing(load_args)) params$load_args <- jsonlite::unbox(load_args)

  res <- httr::GET(splash_url(splash_obj), path="render.har", encode="json", query=params)

  httr::stop_for_status(res)

  out <- httr::content(res, as="text", encoding="UTF-8")
  spl <- jsonlite::fromJSON(out, flatten=FALSE, simplifyVector=FALSE)

  as_har(spl)

}


#' Turn a generic Splash HAR response into a HAR object
#'
#' @param splash_resp splash response object
#' @export
as_har <- function(splash_resp) {

  if (is.raw(splash_resp)) splash_resp <- jsonlite::fromJSON(rawToChar(splash_resp),
                                                             flatten=FALSE,
                                                             simplifyVector=FALSE)

  sphar <- list(
    log=list(
      version=splash_resp$log$version,
      creator=splash_resp$log$creator,
      browser=splash_resp$log$browser,
      pages=splash_resp$log$pages,
      entries=splash_resp$log$entries
    )
  )

  class(sphar$log$creator) <- c("harcreator", "list")
  class(sphar$log$version) <- c("harversion", "character")
  class(sphar$log$browser) <- c("harbrowser", "list")
  class(sphar$log$pages) <- c("harpages", "list")
  class(sphar$log$entries) <- c("harentries", "list")
  class(sphar$log) <- c("harlog", "list")
  class(sphar) <- c("har", "list")

  for (i in 1:length(sphar$log$pages)) class(sphar$log$pages[[i]]) <- c("harpage", "list")
  for (i in 1:length(sphar$log$entries)) {
    class(sphar$log$entries[[i]]) <- c("harentry", "list")
    class(sphar$log$entries[[i]]$request) <- c("harrequest", "list")
    class(sphar$log$entries[[i]]$response) <- c("harresponse", "list")
  }

  sphar


}