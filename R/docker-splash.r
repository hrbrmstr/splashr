#' Retrieve the Docker image for Splash
#'
#' @md
#' @param host Docker host; defaults to `localhost`
#' @return `harbor` `host` object
#' @export
#' @examples \dontrun{
#' install_splash()
#' splash_container <- start_splash()
#' stop_splash(splash_container)
#' }
install_splash <- function(host = harbor::localhost) {
  harbor::docker_pull(host, "hrbrmstr/splashttpd")
}

#' Start a Splash server Docker container
#'
#' If using this in an automation context, you should consider adding a
#' `Sys.sleep(3)` (or higher) after starting the docker container.
#'
#' @param host Docker host; defaults to `localhost`
#' @param add_tempdir This is `FALSE` initially since you could try to run
#'   the splash image on a remote system. It has to be a local one for this to work.
#'   If `TRUE` then a local temporary directory (made with [tempdir]())
#'   will be added to the mount configuration for use with [render_file](). You will need to
#'       ensure the necessary system temp dirs are accessible as a mounts. For
#'       macOS this means adding `/private` to said Docker config.
#' @note you need Docker running on your system and have pulled the container with
#'       [install_splash] for this to work. You should save the resultant `host`
#'       object for use in [stop_splash].
#' @return `harbor` `container` object
#' @export
#' @examples \dontrun{
#' install_splash()
#' splash_container <- start_splash()
#' stop_splash(splash_container)
#' }
start_splash <- function(host = harbor::localhost, add_tempdir=FALSE) {

  doc_opts <- c("-p", "5023:5023",
                "-p", "8050:8050",
                "-p", "8051:8051")

  if (add_tempdir)
    doc_opts <- c(doc_opts,
                  sprintf("--volume=%s", sprintf("%s:/splashfiles", .pkgenv$temp_dir)))

  # purrr::walk(doc_opts, message)

  harbor::docker_run(host,
                     image = "hrbrmstr/splashttpd",
                     detach = TRUE,
                     docker_opts = doc_opts)
}

#' Stop a running a Splash server Docker container
#'
#' @param splash_container Docker `container` object created by [start_splash]
#' @note you need Docker running on your system and have pulled the container with
#'       [install_splash] and started the Splash container with [start_splash] for this
#'       to work. You will need the `container` object from [start_splash] for this to work.
#' @export
#' @examples \dontrun{
#' install_splash()
#' splash_container <- start_splash()
#' stop_splash(splash_container)
#' }
stop_splash <- function(splash_container) {
  harbor::container_rm(splash_container, force=TRUE)
}
