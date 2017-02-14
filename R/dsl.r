make_splash_call <- function(splash_obj) {

  sprintf('
function main(splash)
%s
end
', paste0(sprintf("  %s", splash_obj$calls), collapse="\n")) -> out

  out

}

#' Enable or disable response content tracking.
#'
#' By default Splash doesn’t keep bodies of each response in memory, for efficiency reasons.
#'
#' @param splash_obj splashr object
#' @param enable logical
#' @export
#' @examples \dontrun{
#' splash_local %>%
#'   splash_response_body(TRUE) %>%
#'   splash_go("https://rud.is/b") %>%
#'   splash_wait(2) %>%
#'   splash_har() -> rud_har
#' }
splash_response_body <- function(splash_obj, enable=FALSE) {
  splash_obj$calls <- c(splash_obj$calls, sprintf('splash.response_body_enabled = %s',
                                                  if (enable) "true" else "false"))
  splash_obj
}

#' Enable or disable browser plugins (e.g. Flash).
#'
#' Plugins are disabled by default.
#'
#' @param splash_obj splashr object
#' @param enable logical
#' @export
#' @examples \dontrun{
#' splash_local %>%
#'   splash_plugins(TRUE) %>%
#'   splash_go("https://rud.is/b") %>%
#'   splash_wait(2) %>%
#'   splash_har() -> rud_har
#' }
splash_plugins <- function(splash_obj, enable=FALSE) {
  splash_obj$calls <- c(splash_obj$calls, sprintf('splash.plugins_enabled = %s',
                                                  if (enable) "true" else "false"))
  splash_obj
}

#' Enable/disable images
#'
#' By default, images are enabled. Disabling of the images can save a lot of network
#' traffic (usually around ~50%) and make rendering faster. Note that this option can
#' affect the JavaScript code inside page: disabling of the images may change sizes and
#' positions of DOM elements, and scripts may read and use them.
#'
#' @param splash_obj splashr object
#' @param enable logical
#' @export
#' @examples \dontrun{
#' splash_local %>%
#'   splash_images(TRUE) %>%
#'   splash_go("https://rud.is/b") %>%
#'   splash_wait(2) %>%
#'   splash_har() -> rud_har
#' }
splash_images <- function(splash_obj, enable=TRUE) {
  splash_obj$calls <- c(splash_obj$calls, sprintf('splash.images_enabled  = %s',
                                                  if (enable) "true" else "false"))
  splash_obj
}

#' Go to an URL.
#'
#' This is similar to entering an URL in a browser address bar, pressing Enter and waiting
#' until page loads.
#'
#' @param splash_obj splashr object
#' @param url - URL to load;
#' @export
#' @examples \dontrun{
#' splash_local %>%
#'   splash_response_body(TRUE) %>%
#'   splash_go("https://rud.is/b") %>%
#'   splash_wait(2) %>%
#'   splash_har() -> rud_har
#' }
splash_go <- function(splash_obj, url) {
   splash_obj$calls <- c(splash_obj$calls,
                         sprintf('url = "%s"', url),
                         "splash:go(url)")
   splash_obj
}

#' Wait for a period time
#'
#' When script is waiting WebKit continues processing the webpage
#'
#' @md
#' @param splash_obj splashr object
#' @param time number of seconds to wait
#' @export
#' @examples \dontrun{
#' splash_local %>%
#'   splash_response_body(TRUE) %>%
#'   splash_go("https://rud.is/b") %>%
#'   splash_wait(2) %>%
#'   splash_har() -> rud_har
#' }
splash_wait <- function(splash_obj, time=2) {
   splash_obj$calls <- c(splash_obj$calls, sprintf('splash:wait(%s)', time))
   splash_obj
}

#' Return information about Splash interaction with a website in HAR format.
#'
#' Similar to [render_har] but used in a script context. Should be the LAST element in
#' a DSL script chain as this will execute the script and return the HAR content
#'
#' @md
#' @param splash_obj splashr object
#' @export
#' @examples \dontrun{
#' splash_local %>%
#'   splash_response_body(TRUE) %>%
#'   splash_go("https://rud.is/b") %>%
#'   splash_wait(2) %>%
#'   splash_har() -> rud_har
#' }
splash_har <- function(splash_obj) {

  splash_obj$calls <- c(splash_obj$calls, 'return(splash:har())')

  call_function <- make_splash_call(splash_obj)

  res <- execute_lua(splash_obj, call_function)
  as_har(res)

}

#' Return a HTML snapshot of a current page.
#'
#' Similar to [render_html] but used in a script context. Should be the LAST element in
#' a DSL script chain as this will execute the script and return the HTML content
#'
#' @md
#' @param splash_obj splashr object
#' @param raw_html if `TRUE` then return a character vector vs an XML document.
#' @export
#' @examples \dontrun{
#' splash_local %>%
#'   splash_response_body(TRUE) %>%
#'   splash_go("https://rud.is/b") %>%
#'   splash_wait(2) %>%
#'   splash_html() -> rud_pg
#' }
splash_html <- function(splash_obj, raw_html=FALSE) {

  splash_obj$calls <- c(splash_obj$calls, 'return(splash:html())')

  call_function <- make_splash_call(splash_obj)

  out <- execute_lua(splash_obj, call_function)

  if (!raw_html) out <- xml2::read_html(out)

  out

}

#' Return a screenshot of a current page in PNG format.
#'
#' Similar to [render_png] but used in a script context. Should be the LAST element in
#' a DSL script chain as this will execute the script and return the PNG content
#'
#' @md
#' @param splash_obj splashr object
#' @return a [magick] image object
#' @export
#' @examples \dontrun{
#' splash_local %>%
#'   splash_go("https://rud.is/b") %>%
#'   splash_wait(2) %>%
#'   splash_png()
#' }
splash_png <- function(splash_obj) {

  splash_obj$calls <- c(splash_obj$calls, 'return splash:png{render_all=true}')

  call_function <- make_splash_call(splash_obj)

  res <- execute_lua(splash_obj, call_function)

  magick::image_read(res)

}

