
`splashr` : Tools to Work with the 'Splash' JavaScript Rendering Service

TL;DR: This package works with Splash rendering servers which are really just a REST API & `lua` scripting interface to a QT browser. It's an alternative to the Selenium ecosystem which was really engineered for application testing & validation.

Sometimes, all you need is a page scrape after javascript has been allowed to roam wild and free over your meticulously crafted HTML tags. So, this package does not do *everything* Selenium can, but if you're just trying to get a page back that needs javascript rendering, this is a nice alternative.

It's also an alternative to `phantomjs` (which you can use in R within or without a Selenium context as it's it's own webdriver) and it may be useful to compare renderings between this package & `phantomjs`.

You can also get it running with two commands:

    sudo docker pull scrapinghub/splash
    sudo docker run -p 5023:5023 -p 8050:8050 -p 8051:8051 scrapinghub/splash

(Do whatever you Windows ppl do with Docker on your systems to make ^^ work.)

If using the [`harbor`](https://github.com/wch/harbor) package you can use the convience wrappers in this pacakge:

    install_splash()
    splash_container <- start_splash()

and then run:

    stop_splash(splash_container)

when done. All of that happens on your localhost so use `localhost` as the Splash server parameter.

You can run Selenium in Docker, so this is not unique to Splash. But, a Docker context makes it so that you don't have to run or maintain icky Python stuff directly on your system. Leave it in the abandoned warehouse district where it belongs.

All you need for this package to work is a running Splash instance. You provide the host/port for it and it's scrape-tastic fun from there!

### About Splash

> 'Splash' <https://github.com/scrapinghub/splash> is a javascript rendering service. It’s a lightweight web browser with an 'HTTP' API, implemented in Python using 'Twisted'and 'QT' and provides some of the core functionality of the 'RSelenium' or 'seleniumPipes' R packages but with a Java-free footprint. The (twisted) 'QT' reactor is used to make the sever fully asynchronous allowing to take advantage of 'webkit' concurrency via QT main loop. Some of Splash features include the ability to process multiple webpages in parallel; retrieving HTML results and/or take screenshots; disabling images or use Adblock Plus rules to make rendering faster; executing custom JavaScript in page context; getting detailed rendering info in HAR format.

The following functions are implemented:

-   `render_html`: Return the HTML of the javascript-rendered page.
-   `render_file`: Return the HTML or image (png) of the javascript-rendered page in a local file
-   `render_har`: Return information about Splash interaction with a website in [HAR](http://www.softwareishard.com/blog/har-12-spec/) format.
-   `render_jpeg`: Return a image (in JPEG format) of the javascript-rendered page.
-   `render_png`: Return a image (in PNG format) of the javascript-rendered page.
-   `splash`: Configure parameters for connecting to a Splash server
-   `install_splash`: Retrieve the Docker image for Splash
-   `start_splash`: Start a Splash server Docker container
-   `stop_splash`: Stop a running a Splash server Docker container

Some functions from `HARtools` are imported/exported and `%>%` is imported/exported.

### TODO

Suggest more in a feature req!

-   <strike>Implement `render.json`</strike>
-   <strike>Implement "file rendering"</strike>
-   Implement `execute` (you can script Splash!)
-   <strike>Add integration with [`HARtools`](https://github.com/johndharrison/HARtools)</strike>
-   <strike>*Possibly* writing R function wrappers to install/start/stop Splash</strike> which would also support enabling javascript profiles, request filters and proxy profiles from with R directly, using [`harbor`](https://github.com/wch/harbor)
-   Testing results with all combinations of parameters

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
library(anytime)
library(hrbrmisc) # github
library(htmlwidgets)
library(DiagrammeR)
library(tidyverse)

# current verison
packageVersion("splashr")
```

    ## [1] '0.1.0'

``` r
splash("splash", 8050L) %>%
  splash_active()
```

    ## Status of splash instance on [http://splash:8050]: ok. Max RSS: 462295040

``` r
splash("splash", 8050L) %>%
  splash_debug()
```

    ## List of 7
    ##  $ active  : list()
    ##  $ argcache: int 0
    ##  $ fds     : int 17
    ##  $ leaks   :List of 4
    ##   ..$ Deferred  : int 50
    ##   ..$ LuaRuntime: int 1
    ##   ..$ QTimer    : int 1
    ##   ..$ Request   : int 1
    ##  $ maxrss  : int 451460
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

You can also profile pages:

``` r
splash("splash", 8050L) %>%
  render_har("http://www.poynter.org/") -> har

print(har)
```

    ## --------HAR VERSION-------- 
    ## HAR specification version: 1.2 
    ## --------HAR CREATOR-------- 
    ## Created by: Splash 
    ## version: 2.3.1 
    ## --------HAR BROWSER-------- 
    ## Browser: QWebKit 
    ## version: 538.1 
    ## --------HAR PAGES-------- 
    ## Page id: 1 , Page title: Poynter – A global leader in journalism. Strengthening democracy. 
    ## --------HAR ENTRIES-------- 
    ## Number of entries: 56 
    ## REQUESTS: 
    ## Page: 1 
    ## Number of entries: 56 
    ##   -  http://www.poynter.org/ 
    ##   -  http://www.poynter.org/wp-content/plugins/easy-author-image/css/easy-author-image.css?ver=2016_06_24.1 
    ##   -  http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css?ver=2016_06_24.1 
    ##   -  http://cloud.webtype.com/css/162ac332-3b31-4b73-ad44-da375b7f2fe3.css?ver=2016_06_24.1 
    ##   -  http://maxcdn.bootstrapcdn.com/font-awesome/4.4.0/css/font-awesome.min.css?ver=2016_06_24.1 
    ##      ........ 
    ##   -  http://t.brand-server.com/adj?s=13281&sz=300x250&url=http://www.poynter.org/ 
    ##   -  https://securepubads.g.doubleclick.net/pcs/view?xai=AKAOjsvaVvbr_IQSstPhvzvsWpiYqUHChLUWRLAecmxq6py54Rs-i9aCMEuQR... 
    ##   -  http://srv-2017-02-09-22.pixel.parsely.com/plogger/?rand=1486678060999&idsite=poynter.org&url=http%3A%2F%2Fwww.po... 
    ##   -  http://os4m-d.openx.net/w/1.0/jstag?nc=102766797-YieldLift 
    ##   -  https://securepubads.g.doubleclick.net/pcs/view?xai=AKAOjst2Xvpi5LxMyrFk9_Sw30O5JePbM44dE-0Z7WE046-IhfZcDs-NdDZQD...

You can use [`HARtools::HARviewer`](https://github.com/johndharrison/HARtools/blob/master/R/HARviewer.R) — which this pkg import/exports — to get view the HAR in an interactive HTML widget.

Full web page snapshots are easy-peasy too:

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

### Rendering Widgets

``` r
splash_vm <- start_splash(add_tempdir=TRUE)
```

    ## f9f80950cd30b16c9209412d5578ff53b93b2492d578473ee34e67506014a20e

``` r
DiagrammeR("
  graph LR
    A-->B
    A-->C
    C-->E
    B-->D
    C-->D
    D-->F
    E-->F
") %>% 
  saveWidget("/tmp/diag.html")

splash("localhost") %>% 
  render_file("/tmp/diag.html", output="html")
```

    ## {xml_document}
    ## <html>
    ## [1] <head>\n<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">\n<meta charset="utf-8">\n<script src= ...
    ## [2] <body style="background-color: white; margin: 0px; padding: 40px;">\n<div id="htmlwidget_container">\n<div id="ht ...

``` r
splash("localhost") %>% 
  render_file("/tmp/diag.html", output="png", wait=2)
```

![](img/diag.png)

``` r
stop_splash(splash_vm)
```

    ## f9f80950cd30

### Test Results

``` r
library(splashr)
library(testthat)

date()
```

    ## [1] "Thu Feb  9 17:07:52 2017"

``` r
test_dir("tests/")
```

    ## testthat results ========================================================================================================
    ## OK: 0 SKIPPED: 0 FAILED: 0
    ## 
    ## DONE ===================================================================================================================

### Code of Conduct

Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.
