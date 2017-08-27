0.4.0

* moved to 'docker' pacakge since it's on CRAN
* temporarily removed `render_file()` support
* added code coverage

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
