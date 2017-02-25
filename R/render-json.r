#' Return a json-encoded dictionary with information about javascript-rendered webpage.
#'
#' It can include HTML, PNG and other information, based on arguments passed.
#'
#' @md
#' @rdname render_json
#' @param html Whether to include HTML in output.
#' @param png Whether to include PNG in output.
#' @param jpeg Whether to include JPEG in output.
#' @param iframes Whether to include information about child frames in output.
#' @param script Whether to include the result of the custom executed javascript final
#'               statement in output
#' @param console Whether to include the executed javascript console messages in output.
#' @param history Whether to include the history of requests/responses for webpage main frame.
#'                Use it to get HTTP status codes and headers. Only information about "main"
#'                requests/responses is returned (i.e. information about related resources
#'                like images and AJAX queries is not returned). To get information about all
#'                requests and responses use `har` parameter.
#' @param har Whether to include HAR in output. If `TRUE` the result will contain the same
#'            data as [render_har()] provides under `har` list entry. By default, response
#'            content is not included. To enable it use `response_body` parameter.
#' @param response_body Used with `har` parameter.
#' @return a huge `list`
#' @inheritParams render_jpeg
#' @note All "whether to include..." parameters are default `TRUE` except for `png` and
#'       `jpeg` and a custom `print` method is defined to stop your console from being
#'       overwhelmed with data. Use [str()] to inspect various portions of the result.
#' @references [Splash docs](http://splash.readthedocs.io/en/stable/index.html)
#' @export
render_json <- function(splash_obj = splash_local, url, base_url=NULL, quality=75, width, height,
                        timeout=30, resource_timeout, wait=0, render_all=FALSE,
                        proxy, js, js_src, filters, allowed_domains, allowed_content_types,
                        forbidden_content_types, viewport="1024x768", images, headers, body,
                        http_method, save_args, load_args, html=TRUE, png=FALSE, jpeg=FALSE,
                        iframes=TRUE, script=TRUE, console=TRUE, history=TRUE, har=TRUE,
                        response_body=FALSE) {

  params <- list(url=url, timeout=timeout, wait=wait, viewport=jsonlite::unbox(viewport),
                 quality=quality, render_all=as.numeric(render_all),
                 html=as.numeric(html), png=as.numeric(png), jpeg=as.numeric(jpeg),
                 iframes=as.numeric(iframes), script=as.numeric(script),
                 console=as.numeric(console), history=as.numeric(history), har=as.numeric(har),
                 response_body=as.numeric(response_body))

  if (!missing(width)) params$width <- width
  if (!missing(height)) params$height <- height

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

  res <- httr::GET(splash_url(splash_obj), path="render.json", encode="json", query=params)

  httr::stop_for_status(res)

  out <- httr::content(res, as="text", encoding="UTF-8")
  out <- jsonlite::fromJSON(out, flatten=FALSE, simplifyVector=FALSE)

  class(out) <- c("splash_json", class(out))

  if ("har" %in% names(out)) {

    sphar <- list(
      log=list(
        version=out$har$log$version,
        creator=out$har$log$creator,
        browser=out$har$log$browser,
        pages=out$har$log$pages,
        entries=out$har$log$entries
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
      if (length(sphar$log$entries[[i]]$request) > 0) class(sphar$log$entries[[i]]$request) <- c("harrequest", "list")
      if (length(sphar$log$entries[[i]]$response) > 0) class(sphar$log$entries[[i]]$response) <- c("harresponse", "list")
    }

    out$har <- sphar

  }

  out

}

#' @export
print.splash_json <- function(x, ...) {
  cat("<splashr render_json() object>")
  invisible(x)
}