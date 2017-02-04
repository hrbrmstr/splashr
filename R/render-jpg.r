#' Return a image (in JPEG format) of the javascript-rendered page.
#'
#' @md
#' @param quality JPEG quality parameter in range from 0 to 100. Default is quality=75.
#' @inheritParams render_html
#' @inheritParams render_png
#' @references [Splash docs](http://splash.readthedocs.io/en/stable/index.html)
#' @export
render_jpeg <- function(splash_obj, url, base_url=NULL, quality=75, width=1024, height=768,
                        timeout=30, resource_timeout, wait=0, render_all=FALSE,
                        proxy, js, js_src, filters, allowed_domains, allowed_content_types,
                        forbidden_content_types, viewport="1024x768", images, headers, body,
                        http_method, save_args, load_args) {

  params <- list(url=url, timeout=timeout, wait=wait, viewport=viewport,
                 quality=quality, width=width, height=height, render_all=as.numeric(render_all))

  if (!missing(base_url)) params$base_url <- base_url
  if (!missing(resource_timeout)) params$resource_timeout <- resource_timeout
  if (!missing(proxy)) proxy$base_url <- proxy
  if (!missing(js)) params$js <- js
  if (!missing(js_src)) params$js_src <- js_src
  if (!missing(filters)) params$filters <- filters
  if (!missing(allowed_domains)) params$allowed_domains <- allowed_domains
  if (!missing(allowed_content_types)) params$allowed_content_types <- allowed_content_types
  if (!missing(forbidden_content_types)) params$forbidden_content_types <- forbidden_content_types
  if (!missing(images)) params$images <- images
  if (!missing(headers)) params$headers <- headers
  if (!missing(body)) params$body <- body
  if (!missing(http_method)) params$http_method <- http_method
  if (!missing(save_args)) params$save_args <- save_args
  if (!missing(load_args)) params$load_args <- load_args

  res <- httr::GET(splash_url(splash_obj), path="render.jpeg", encode="json", query=params)

  httr::stop_for_status(res)

  magick::image_read(httr::content(res, as="raw"))

}