## Test environments

* local OS X install, R 3.4.1 on both 10.12 and 10.13 Beta 6
* local ubuntu 3.4.1 and r-devel
* ubuntu on travis-ci, R oldrel, 3.4.1 and r-devel
* win-builder (devel and release)

## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new release.

## Reverse dependencies

This is a new release, so there are no reverse dependencies.

---

Hey folks,

The tests skip on CRAN and the examples are \dontrun{} because
they require an active Splash server running for the most 
accurate results (mocking would not exercise the interaction with
the Splash API server). The core functionality is much the same
as RSelenium, but Splash is more designed for scraping
than Selenium which is more geared towards web site automated
testing. This will hopefully be a nice addition to the R web
scraping world.

It is fully tested on Travis: https://travis-ci.org/hrbrmstr/splashr
with 2 different Python configurations across all three R versions. 
It's an active test that spins up a local Docker container and runs
on push and weekly. (It imports the 'docker' package, hence my
mentioning the diverse python configs).

Neither Appveyor (and, all other free Windows CI systems) nor
rhub nor WinBuilder support co-runbninbg Docker linux containers 
so the tests are not run there, but the package is built regularly 
on WinBuilder and rhub's Windows and "CRAN" environments to 
catch any other platform-related package errors.

There are many Imports because this works with a diverse amount
of web content and also tries to play well with 'httr' and 'rvest'
as well as the 'hartools' package.

There are three vignettes and I tried to reduce the image sizes
for the figures in them as much as possible. I'll glady do some 
cropping if you would like the total size to be even smaller. I 
fully understand wanting to keep pacakges as small as possible.

The package is also well-documented and has 44% code coverage:
https://codecov.io/gh/hrbrmstr/splashr/tree/master/R
I'm going to get that up closer to 80% for the next release which will 
extend the "DSL" functions.

Thx for your time & efforts!

-boB

P.S. Hope you folks had a great summer!
