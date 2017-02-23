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
#'   splash_user_agent(ua_macos_chrome) %>%
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
#'   splash_user_agent(ua_macos_chrome) %>%
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
#'   splash_user_agent(ua_macos_chrome) %>%
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
#'   splash_user_agent(ua_macos_chrome) %>%
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

#' Trigger mouse click event in web page.
#'
#' @param splash_obj splashr object
#' @param x,y coordinates (distances from the left or top, relative to the current viewport)
#' @export
splash_click <- function(splash_obj, x, y) {
   splash_obj$calls <- c(splash_obj$calls,
                         sprintf("splash:mouse_click(%s, %s)", x, y))
   splash_obj
}

#' Focus on a document element provided by a CSS selector
#'
#' @md
#' @param splash_obj splashr object
#' @param selector valid CSS selector
#' @references See [the docs](https://splash.readthedocs.io/en/stable/scripting-ref.html#splash-send-text) for more info
#' @export
splash_focus <- function(splash_obj, selector) {
   splash_obj$calls <- c(splash_obj$calls,
                         sprintf('splash:select("%s").node:focus()', selector))
   splash_obj
}

#' Send text as input to page context, literally, character by character.
#'
#' This is different from [splash_send_keys]
#'
#' @md
#' @note This adds a call to `splash:wait` so you do not have to
#' @param splash_obj splashr object
#' @param text string to send
#' @references See [the docs](https://splash.readthedocs.io/en/stable/scripting-ref.html#splash-send-keys) for more info
#' @export
splash_send_text <- function(splash_obj, text) {
   splash_obj$calls <- c(splash_obj$calls,
                         sprintf('splash:send_text("%s")', text),
                         "splash:wait(0.1)")
   splash_obj
}

#' Send keyboard events to page context.
#'
#' - whitespace is ignored and only used to separate the different keys
#' - characters are literally represented
#'
#' This is different from [splash_send_text]
#'
#' @md
#' @param splash_obj splashr object
#' @param keys string to send
#' @references See [the docs](https://splash.readthedocs.io/en/stable/scripting-ref.html#splash-send-keys) for more info
#' @export
splash_send_keys <- function(splash_obj, keys) {
   splash_obj$calls <- c(splash_obj$calls,
                         sprintf('splash:send_keys("%s")', keys),
                         "splash:wait(0.1)")
   splash_obj
}

#' Trigger mouse release event in web page.
#'
#' @param splash_obj splashr object
#' @param x,y coordinates (distances from the left or top, relative to the current viewport)
#' @export
splash_release <- function(splash_obj, x, y) {
   splash_obj$calls <- c(splash_obj$calls,
                         sprintf("splash:mouse_release(%s, %s)", x, y))
   splash_obj
}

#' Trigger mouse press event in web page.
#'
#' @param splash_obj splashr object
#' @param x,y coordinates (distances from the left or top, relative to the current viewport)
#' @export
splash_press <- function(splash_obj, x, y) {
   splash_obj$calls <- c(splash_obj$calls,
                         sprintf("splash:mouse_press(%s, %s)", x, y))
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
#'   splash_user_agent(ua_macos_chrome) %>%
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
#'   splash_user_agent(ua_macos_chrome) %>%
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
#'   splash_user_agent(ua_macos_chrome) %>%
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
#'   splash_user_agent(ua_macos_chrome) %>%
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

#' Overwrite the User-Agent header for all further requests.
#'
#' There are a few built-in user agents, all beginning with `ua_`.
#'
#' @md
#' @param splash_obj splashr object
#' @param user_agent 1 element character vector, defaults to `splashr/#.#.#`.
#' @export
#' @examples \dontrun{
#' library(rvest)
#'
#' URL <- "https://httpbin.org/user-agent"
#'
#' splash_local %>%
#'   splash_response_body(TRUE) %>%
#'   splash_user_agent(ua_macos_chrome) %>%
#'   splash_go(URL) %>%
#'   splash_html() %>%
#'   html_text("body") %>%
#'   jsonlite::fromJSON()
#' }
splash_user_agent <- function(splash_obj, user_agent=ua_splashr) {
  splash_obj$calls <- c(splash_obj$calls, sprintf('splash:set_user_agent("%s")', user_agent))
  splash_obj
}

#' @rdname splash_user_agent
#' @export
ua_splashr <- sprintf("splashr/%s", packageVersion("splashr"))

#' @rdname splash_user_agent
#' @export
ua_win10_chrome <- "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/55.0.2883.87 Safari/537.36"

#' @rdname splash_user_agent
#' @export
ua_win10_firefox <- "Mozilla/5.0 (Windows NT 10.0; WOW64; rv:51.0) Gecko/20100101 Firefox/51.0"

#' @rdname splash_user_agent
#' @export
ua_win10_ie11 <- "Mozilla/5.0 (Windows NT 10.0; WOW64; Trident/7.0; rv:11.0) like Gecko"

#' @rdname splash_user_agent
#' @export
ua_win7_chrome <- "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/55.0.2883.87 Safari/537.36"

#' @rdname splash_user_agent
#' @export
ua_win7_firefox <- "Mozilla/5.0 (Windows NT 6.1; WOW64; rv:51.0) Gecko/20100101 Firefox/51.0"

#' @rdname splash_user_agent
#' @export
ua_win7_ie11 <- "Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko"

#' @rdname splash_user_agent
#' @export
ua_macos_chrome <- "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/55.0.2883.95 Safari/537.36"

#' @rdname splash_user_agent
#' @export
ua_macos_safari <- "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_2) AppleWebKit/602.3.12 (KHTML, like Gecko) Version/10.0.2 Safari/602.3.12"

#' @rdname splash_user_agent
#' @export
ua_linux_chrome <- "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/55.0.2883.87 Safari/537.36"

#' @rdname splash_user_agent
#' @export
ua_linux_firefox <- "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:51.0) Gecko/20100101 Firefox/51.0"

#' @rdname splash_user_agent
#' @export
ua_ios_safari <- "Mozilla/5.0 (iPad; CPU OS 10_2 like Mac OS X) AppleWebKit/602.3.12 (KHTML, like Gecko) Version/10.0 Mobile/14C92 Safari/602.1"
