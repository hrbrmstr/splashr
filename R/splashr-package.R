#' Tools to Work with the 'Splash' JavaScript Rendering Service
#'
#' 'Splash' <https://github.com/scrapinghub/splash> is a javascript rendering service.
#' It’s a lightweight web browser with an 'HTTP' API, implemented in Python using
#' 'Twisted'and 'QT' and provides some of the core functionality of the 'RSelenium' or
#' 'seleniumPipes'R pacakges but with a Java-free footprint. The (twisted) 'QT' reactor is
#' used to make the sever fully asynchronous allowing to take advantage of 'webkit'
#' concurrency via QT main loop. Some of Splash features include the ability to process
#' multiple webpages in parallel; retrieving HTML results and/or take screenshots;
#' disabling images or use Adblock Plus rules to make rendering faster; executing custom
#' JavaScript in page context; getting detailed rendering info in HAR format.
#'
#' @md
#' @name splashr
#' @docType package
#' @author Bob Rudis (bob@@rud.is)
#' @import purrr httr magick
#' @importFrom xml2 read_html url_parse
#' @importFrom jsonlite fromJSON
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
