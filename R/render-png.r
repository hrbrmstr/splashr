#' Return a image (in PNG format) of the javascript-rendered page.
#'
#' @md
#' @param width,height Resize the rendered image to the given width/height (in pixels) keeping the aspect ratio.
#' @param render_all If `TRUE` extend the viewport to include the whole webpage (possibly very tall) before rendering. Default is `FASLE`
#' @inheritParams render_html
#' @export
render_png <- function(splash_obj, url, base_url=NULL, width=1024, height=768, render_all=FALSE,
                       timeout=30, resource_timeout=NULL, wait=0,
                       proxy, js, js_src, filters, allowed_domains="", allowed_content_types="",
                       forbidden_content_types="", viewport="1024x768", images, headers, body,
                       http_method, save_args, load_args) {

  res <- httr::GET(splash_url(splash_obj), path="render.png",
                   encode="json",
                   query=list(url=url, timeout=timeout, wait=wait, viewport=viewport,
                              width=width, height=height, render_all=as.numeric(render_all)))

  httr::stop_for_status(res)

  magick::image_read(httr::content(res, as="raw"))

}