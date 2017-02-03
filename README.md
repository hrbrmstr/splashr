
`splashr` : Tools to Work with the 'Splash' JavaScript Rendering Service

**Ridicuously basic functionality working at the moment. More coming soon**

TL;DR: This package works with Splash rendering servers which are really just a REST API & `lua` scripting interface to a QT browser. It's an alternative to the Selenium ecosystem and does not do everything Selenium can, but if you're just trying to get a page back that needs javascript rendering, this is a nice alternative.

You can also get it running with two commands:

    sudo docker pull scrapinghub/splash
    sudo docker run -p 5023:5023 -p 8050:8050 -p 8051:8051 scrapinghub/splash

(Do whatever you Windows ppl do with Docker on your systems to make ^^ work.)

All you need for this package to work is a running Splash instance. You provide the host/port for it and it's scrape-tastic from there.

### About Splash

> 'Splash' <https://github.com/scrapinghub/splash> is a javascript rendering service. It’s a lightweight web browser with an 'HTTP' API, implemented in Python using 'Twisted'and 'QT' and provides some of the core functionality of the 'RSelenium' or 'seleniumPipes'R pacakges but with a Java-free footprint. The (twisted) 'QT' reactor is used to make the sever fully asynchronous allowing to take advantage of 'webkit' concurrency via QT main loop. Some of Splash features include the ability to process multiple webpages in parallel; retrieving HTML results and/or take screenshots; disabling images or use Adblock Plus rules to make rendering faster; executing custom JavaScript in page context; getting detailed rendering info in HAR format.

The following functions are implemented:

-   `render_html`: Return the HTML of the javascript-rendered page.
-   `render_jpeg`: Return a image (in JPEG format) of the javascript-rendered page.
-   `render_png`: Return a image (in PNG format) of the javascript-rendered page.
-   `splash`: Configure parameters for connecting to a Splash server
-   `splashr`: Tools to Work with the 'Splash' JavaScript Rendering Service

### Installation

``` r
devtools::install_github("hrbrmstr/splashr")
```

``` r
options(width=120)
```

### Usage

``` r
library(splashr)
library(magick)
library(rvest)

# current verison
packageVersion("splashr")
```

    ## [1] '0.1.0'

``` r
splash("splash", 8050L) %>%
  splash_active()
```

    ## Status of splash instance on [http://splash:8050]: ok. Max RSS: 349298688

``` r
splash("splash", 8050L) %>%
  splash_debug()
```

    ## List of 7
    ##  $ active  : list()
    ##  $ argcache: int 0
    ##  $ fds     : int 18
    ##  $ leaks   :List of 4
    ##   ..$ Deferred  : int 50
    ##   ..$ LuaRuntime: int 1
    ##   ..$ QTimer    : int 1
    ##   ..$ Request   : int 1
    ##  $ maxrss  : int 341112
    ##  $ qsize   : int 0
    ##  $ url     : chr "http://splash:8050"
    ##  - attr(*, "class")= chr [1:2] "splash_debug" "list"
    ## NULL

Notice the difference between a rendered HTML scrape and a non-rendered one:

``` r
splash("splash", 8050L) %>%
  render_html("http://marvel.com/universe/Captain_America_(Steve_Rogers)")
```

    ## {xml_document}
    ## <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en" dir="ltr">
    ## [1] <head>\n<script src="http://widget-cdn.rpxnow.com/manifest/login?version=1.114.1_widgets_244" type="text/javascri ...
    ## [2] <body id="index-index" class="index-index" onload="findLinks('myLink');">\n\n\t<div id="page_frame" style="overfl ...

``` r
read_html("http://marvel.com/universe/Captain_America_(Steve_Rogers)")
```

    ## {xml_document}
    ## <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en" dir="ltr">
    ## [1] <head>\n<meta http-equiv="X-UA-Compatible" content="IE=Edge">\n<link href="https://plus.google.com/10852333737344 ...
    ## [2] <body id="index-index" class="index-index" onload="findLinks('myLink');">\n\n\t<div id="page_frame" style="overfl ...

Web page snapshots are easy-peasy too:

``` r
splash("splash", 8050L) %>%
  render_png("http://marvel.com/universe/Captain_America_(Steve_Rogers)")
```

![](img/cap.png)

``` r
splash("splash", 8050L) %>%
  render_jpeg("http://marvel.com/universe/Captain_America_(Steve_Rogers)") 
```

![](img/cap.jpg)

### Test Results

``` r
library(splashr)
library(testthat)

date()
```

    ## [1] "Fri Feb  3 14:58:40 2017"

``` r
test_dir("tests/")
```

    ## testthat results ========================================================================================================
    ## OK: 0 SKIPPED: 0 FAILED: 0
    ## 
    ## DONE ===================================================================================================================
