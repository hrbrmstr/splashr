#' Return the HTML or image (png) of the javascript-rendered page in a local file
#'
#' The suggested use-case for this is rendering a widget
#'
#' TODO Test if container is running
#' TODO Enable passing in of an htmlwidget and use saveWidget
#'
#' @md
#' @param splash_obj Object created by a call to [splash]()
#' @param file_path Absolute path to a filename on the local host. **This only works with a locally running Splash instance started with [start_splash]().**
#' @param wait seconds to wait
#' @param output either `html` or `png` to get the page content or an image capture
#' @param viewport View width and height (in pixels) of the browser viewport to render the web page. Format is "`<width>x<height>`". e.g. 800x600. Default value is 1024x768.
#' @param ... other params to [render_html]() or [render_png]()
#' @return An XML document or `magick` object
#' @export
render_file <- function(splash_obj = splash_local, file_path, output=c("html", "png"), wait=0, viewport="1024x768", ...) {

  output <- match.arg(output, c("html", "png"))

  file.copy(file_path, .pkgenv$temp_dir)

  fil <- basename(file_path)

  URL <- sprintf("http://localhost:9999/%s", fil)

  if (output == "html") {
    render_html(splash_obj, URL, wait=wait, viewport=viewport, ...)
  } else {
    render_png(splash_obj, URL, wait=wait, viewport=viewport, ...)
  }

}

