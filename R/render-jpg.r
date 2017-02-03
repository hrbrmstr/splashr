#' Return a image (in JPEG format) of the javascript-rendered page.
#'
#' @md
#' @param quality JPEG quality parameter in range from 0 to 100. Default is quality=75.
#' @inheritParams render_html
#' @inheritParams render_png
#' @export
render_jpeg <- function(splash_obj, url, base_url=NULL, quality=75, width=1024, height=768,
                        timeout=30, resource_timeout=NULL, wait=0, render_all=FALSE,
                        proxy, js, js_src, filters, allowed_domains="", allowed_content_types="",
                        forbidden_content_types="", viewport="1024x768", images, headers, body,
                        http_method, save_args, load_args) {

  res <- httr::GET(splash_url(splash_obj), path="render.jpeg",
                   encode="json",
                   query=list(url=url, timeout=timeout, wait=wait, viewport=viewport,
                              quality=quality, width=width, height=height, render_all=as.numeric(render_all)))

  httr::stop_for_status(res)

  magick::image_read(httr::content(res, as="raw"))

}