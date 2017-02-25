#' Return a image (in PNG format) of the javascript-rendered page.
#'
#' @md
#' @param width,height Resize the rendered image to the given width/height (in pixels) keeping the aspect ratio. These are optional
#' @param render_all If `TRUE` extend the viewport to include the whole webpage (possibly very tall) before rendering.
#' @return a [magick] image object
#' @references [Splash docs](http://splash.readthedocs.io/en/stable/index.html)
#' @inheritParams render_html
#' @export
render_png <- function(
  splash_obj = splash_local, url, base_url=NULL, width, height,
  timeout=30, resource_timeout, wait=0, render_all=TRUE,
  proxy, js, js_src, filters, allowed_domains, allowed_content_types,
  forbidden_content_types, viewport="full", images, headers, body,
  http_method, save_args, load_args) {

  params <- list(url=url, timeout=timeout,
                 wait=if (render_all & wait == 0) 0.5 else wait,
                 viewport=jsonlite::unbox(viewport),
                 render_all=as.numeric(render_all))

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

  res <- httr::GET(splash_url(splash_obj), path="render.png", encode="json", query=params)

  httr::stop_for_status(res)

  magick::image_read(httr::content(res, as="raw"))

}

