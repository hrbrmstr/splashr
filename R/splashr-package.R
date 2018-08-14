#' Tools to Work with the 'Splash' JavaScript Rendering Service
#'
#' 'Splash' <https://github.com/scrapinghub/splash> is a 'JavaScript' rendering service.
#'  It’s a lightweight web browser with an 'HTTP' API, implemented in 'Python' using 'Twisted'
#'  and 'QT' and provides some of the core functionality of the 'RSelenium' or 'seleniumPipes'
#'  R pacakges in a lightweight footprint.
#'
#'  Some of 'Splash' features include the ability to process
#'  multiple webpages in parallel; retrieving 'HTML' results and/or take screenshots; disabling
#'  images or use 'Adblock Plus' rules to make rendering faster; executing custom 'JavaScript' in
#'  page context; getting detailed rendering info in 'HAR' format.
#'
#' @md
#' @name splashr
#' @docType package
#' @author Bob Rudis (bob@@rud.is)
#' @import purrr httr magick docker
#' @importFrom stringi stri_split_regex stri_split_fixed stri_detect_regex stri_split_lines
#' @importFrom HARtools writeHAR HARviewer renderHARviewer HARviewerOutput
#' @importFrom xml2 read_html url_parse
#' @importFrom jsonlite fromJSON unbox stream_in
#' @importFrom openssl base64_decode
#' @importFrom lubridate ymd_hms
#' @importFrom scales comma
#' @importFrom stats setNames
#' @importFrom formatR tidy_source
#' @importFrom utils capture.output str
#' @importFrom curl curl_unescape
#' @importFrom dplyr data_frame as_data_frame
NULL

#' splashr exported operators
#'
#' The following functions are imported and then re-exported
#' from the splashr package to enable use of the magrittr
#' pipe operator with no additional library calls
#'
#' @name splashr-exports
NULL

#' @name %>%
#' @export
#' @rdname splashr-exports
NULL

#' @name writeHAR
#' @export
#' @rdname splashr-exports
NULL

#' @name HARviewer
#' @export
#' @rdname splashr-exports
NULL

#' @name renderHARviewer
#' @export
#' @rdname splashr-exports
NULL

#' @name HARviewerOutput
#' @export
#' @rdname splashr-exports
NULL
