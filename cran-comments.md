## Test environments

* local macOS install, R 3.5.2 on both macOS 10.14
* local ubuntu 3.5.1
* ubuntu on travis-ci, R oldrel, current and r-devel
* win-builder (devel and release)

---

Per a note from Kurt the splashr now uses the
stevedore package since the docker package is
likely being retired from CRAN.

The invalid URL in the vignette (as noted in
an email thread) has been fixed.

Tests require instllation of ~1.2GB docker image
which also means docker needs to be available.
Examples also require a Splash instance (dockerized
or full install) to work. Therefore, as has been the
case since the previous CRAN version, examples
are marked as dontrun and tests do not run on CRAN.
They do run monthly and on every repo push in Travis
https://travis-ci.org/hrbrmstr/splashr/settings.

I can modify any of the above behavior to conform
to any CRAN policy I may be violating.

License has been changed to MIT.

As always, thanks to the CRAN team for their
herculean efforts to keep the R package universe
healthy!