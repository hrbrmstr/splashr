0.7.0
* Changed `as[._]data[._]frame()` function to `tidy_har()`
* Improved API error messages
* Added support for `http2` (<https://splash.readthedocs.io/en/stable/changes.html#id1>)
* Added support for the alpha/experimental Splash chromium engine
  (<https://splash.readthedocs.io/en/stable/changes.html#id2>)

0.6.0

* Switch Docker orchestration to the `stevedore` package
* Fixed minor check on as.data.frame functions
* Cleaned up splashr object printing
* Added Android, Kindle, Apple TV & Chromecast user agents and updated 
  other user agents
* Updated Travis config to not use old docker pkg components

0.5.0

* support Splash API basic auth
* `as_data_frame`/`as.data.frame` methods for HAR objects

0.4.1

* removed clipr usage due to CRAN

0.4.0

* moved to 'docker' pacakge since it's on CRAN
* temporarily removed `render_file()` support
* added code coverage
* CRAN release 

0.3.0

* added basic pkg tests
* added mini-DSL to avoid needing to write lua scripts for some common operations
* added many tests for many types of objects
* added HAR support
* added `as_req()`
* added `as_request()`
* added `wait` value range check for `render_` functions (min 0, max 10)

0.2.0

* added `execute`()
* modified `splash_active`()
* added `splash_local` global variable to avoid typing `splash("localhost")`

0.1.0 

* Initial release
