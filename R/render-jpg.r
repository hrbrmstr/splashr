#' Return a image (in JPEG format) of the javascript-rendered page.
#'
#' @md
#' @param quality JPEG quality parameter in range from 0 to 100. Default is quality=75.
#' @inheritParams render_html
#' @inheritParams render_png
#' @return a [magick] image object
#' @references [Splash docs](http://splash.readthedocs.io/en/stable/index.html)
#' @export
render_jpeg <- render_jpg <- function(
  splash_obj = splash_local, url, base_url=NULL, quality=75, width, height,
  timeout=30, resource_timeout, wait=0, render_all=TRUE,
  proxy, js, js_src, filters, allowed_domains, allowed_content_types,
  forbidden_content_types, viewport="full", images, headers, body,
  http_method, save_args, load_args) {

  wait <- check_wait(wait)

  params <- list(url=url, timeout=timeout,
                 wait=if (render_all & wait == 0) 0.5 else wait,
                 viewport=viewport,
                 quality=quality,
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

  res <- httr::GET(splash_url(splash_obj), path="render.jpeg", encode="json", query=params)

  httr::stop_for_status(res)

  magick::image_read(httr::content(res, as="raw"))

}

