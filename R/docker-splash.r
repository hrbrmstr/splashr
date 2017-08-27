#' Retrieve the Docker image for Splash
#'
#' @md
#' @param tag Splash Docker image tag to install
#' @export
#' @family splash_docker_helpers
#' @examples \dontrun{
#' install_splash()
#' splash_container <- start_splash()
#' stop_splash(splash_container)
#' }
install_splash <- function(tag="3.0") {
  client <- docker::docker$from_env()
  res <- client$api$pull("scrapinghub/splash", tag)
  res <- jsonlite::stream_in(textConnection(res), verbose=FALSE)
  invisible(lapply(res$status, function(x) { message(x) }))
}

#' Start a Splash server Docker container
#'
#' If using this in an automation context, you should consider adding a
#' `Sys.sleep(3)` (or higher) after starting the docker container.
#'
#' @param tag Splash Docker image tag to start
#' @note you need Docker running on your system and have pulled the container with
#'       [install_splash] for this to work. You should save the resultant
#'       object for use in [stop_splash] otherwise you'll have to kill it from the
#'       command line interface.
#' @family splash_docker_helpers
#' @return `docker` `container` object
#' @export
#' @examples \dontrun{
#' install_splash()
#' splash_container <- start_splash()
#' stop_splash(splash_container)
#' }
start_splash <- function(tag="3.0") {

  client <- docker::docker$from_env()

  splash_inst <- client$containers$run(
    sprintf("scrapinghub/splash:%s", tag), name="splashr",
    detach=TRUE, ports=list('8050/tcp'='8050', '5023/tcp'='5023', '8051/tcp'='8051')
  )

  invisible(splash_inst)

}

#' Stop a running a Splash server Docker container
#'
#' @param splash_container Docker `container` object created by [start_splash()]
#' @note you need Docker running on your system and have pulled the container with
#'       [install_splash()] and started the Splash container with [start_splash()] for this
#'       to work. You will need the `container` object from [start_splash()] for this to work.
#' @family splash_docker_helpers
#' @export
#' @examples \dontrun{
#' install_splash()
#' splash_container <- start_splash()
#' stop_splash(splash_container)
#' }
stop_splash <- function(splash_container) {
  splash_container$stop()
  splash_container$remove()
}

#' Prune all dead and running Splash Docker containers
#'
#' _This is a destructive function._ It will stop **any** Docker container that
#' is based on an image matching "`scrapinghub/splashr`". It's best used when you
#' had a session forcefully interuppted and had been using the R helper functions
#' to start/stop the Splash Docker container. You may want to consider using the
#' Docker command-line interface to perform this work manually.
#'
#' @export
killall_splash <- function() {

  client <- docker::docker$from_env()
  x <- client$containers$list(all = TRUE)

  for (cntnr in x) {
    if (grepl("scrapinghub/splash", cntnr$image$tags[1])) {
      message(sprintf("Pruning: %s...", cntnr$id))
      if (cntnr$status == "running") cntnr$stop()
      cntnr$remove()
    }
  }
}


# @param add_tempdir This is `FALSE` initially since you could try to run
#   the splash image on a remote system. It has to be a local one for this to work.
#   If `TRUE` then a local temporary directory (made with [tempdir()])
#   will be added to the mount configuration for use with [render_file()]. You will need to
#       ensure the necessary system temp dirs are accessible as a mounts. For
#       macOS this means adding `/private` to said Docker config.
