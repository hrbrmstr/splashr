context("basic functionality")
test_that("we can do something", {

  testthat::skip_on_cran()

  test_url <- "http://localhost:8050/"

  xpct <- function(x) {
    spact <- splash_active()
    expect_that(spact, equals(TRUE))
    expect_that(length(splash_debug()), equals(7))
    expect_that(length(splash_version()), equals(9))
    expect_that(render_json(url = test_url), is_a("splash_json"))
    expect_that(render_jpeg(url = test_url), is_a("magick-image"))
    expect_that(render_png(url = test_url), is_a("magick-image"))
    expect_that(render_html(url = test_url), is_a("xml_document"))
    expect_that(render_har(url = test_url), is_a("har"))
  }

  spact <- splash_active()

  if (spact) {
    xpct()
  } else {
    install_splash()
    vm <- start_splash()
    Sys.sleep(15)
    xpct()
    stop_splash(vm)
  }

})
