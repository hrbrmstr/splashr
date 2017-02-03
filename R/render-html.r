#' Return the HTML of the javascript-rendered page.
#'
#' Similar to `rvest::read_html`.
#'
#' @md
#' @param splash_obj Object created by a call to [splash]
#' @param url The URL to render (required)
#' @param base_url TBD The base url to render the page with.
#' @param timeout TBD A timeout (in seconds) for the render (defaults to 30).
#' @param resource_timeout A timeout (in seconds) for individual network requests.
#' @param wait Time (in seconds) to wait for updates after page is loaded (defaults to 0).
#' @param proxy TBD Proxy profile name or proxy URL.
#' @param js TBD Javascript profile name.
#' @param js_src TBD JavaScript code to be executed in page context.
#' @param filters TBD Comma-separated list of request filter names.
#' @param allowed_domains TBD Comma-separated list of allowed domain names. If present, Splash won’t load anything neither from domains not in this list nor from subdomains of domains not in this list.
#' @param allowed_content_types TBD Comma-separated list of allowed content types. If present, Splash will abort any request if the response’s content type doesn’t match any of the content types in this list. Wildcards are supported.
#' @param forbidden_content_types TBD Comma-separated list of forbidden content types. If present, Splash will abort any request if the response’s content type matches any of the content types in this list. Wildcards are supported.
#' @param viewport View width and height (in pixels) of the browser viewport to render the web page. Format is “<width>x<height>”, e.g. 800x600. Default value is 1024x768.
#' @param images TBD Whether to download images.
#' @param headers TBD HTTP headers to set for the first outgoing request.
#' @param body TBD Body of HTTP POST request to be sent if method is POST.
#' @param http_method TBD HTTP method of outgoing Splash request.
#' @param save_args TBD A list of argument names to put in cache.
#' @param load_args TBD Parameter values to load from cache
#' @export
render_html <- function(splash_obj, url, base_url, timeout=30, resource_timeout=NULL, wait=0,
                        proxy, js, js_src, filters, allowed_domains="", allowed_content_types="",
                        forbidden_content_types="", viewport="1024x768", images, headers, body,
                        http_method, save_args, load_args) {

  res <- httr::GET(splash_url(splash_obj), path="render.html",
                   encode="json",
                   query=list(url=url, timeout=timeout, wait=wait, viewport=viewport))

  httr::stop_for_status(res)

  httr::content(res, as="text", encoding="UTF-8") %>%
    xml2::read_html()

}