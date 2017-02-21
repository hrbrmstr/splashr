context("basic functionality")
test_that("we can do something", {

  spact <- splash_active()

  expect_that(spact, equals(TRUE))

  if (spact) {

    expect_that(length(splash_debug()), equals(7))
    expect_that(length(splash_version()), equals(9))
    expect_that(render_json(url = "https://httpbin.org/get"), is_a("splash_json"))
    expect_that(render_png(url = "https://httpbin.org/get"), is_a("magick-image"))
    expect_that(render_png(url = "https://httpbin.org/get"), is_a("magick-image"))
    expect_that(render_html(url = "https://httpbin.org/get"), is_a("xml_document"))
    expect_that(render_har(url = "https://httpbin.org/get"), is_a("har"))

  }

})
