#' Retrieve the Docker image for Splash
#'
#' @md
#' @param tag Splash Docker image tag to install
#' @return a `docker_image` object or `NULL` if an error occurred.
#' @export
#' @family splash_docker_helpers
#' @examples \dontrun{
#' install_splash()
#' splash_container <- start_splash()
#' stop_splash(splash_container)
#' }
install_splash <- function(tag="latest") {

  docker <- stevedore::docker_client()

  tryCatch(
    docker$image$pull("scrapinghub/splash", tag=tag, stream=stdout()),
    error = function(e) {
      message("Error pulling image from DockerHub.\n", e)
      return(NULL)
    },
    interrupt = function(e) {
      stop("Terminated by user", call. = FALSE)
    }
  ) -> res

  invisible(res)

}

#' Start a Splash server Docker container
#'
#' If using this in an automation context, you should consider adding a
#' `Sys.sleep(3)` (or higher) after starting the docker container.
#'
#' This uses the `latest` image and passed the `--disable-browser-caches`
#' parameter. If you do not want to use the 3.2.x+ versions of `Splash`
#' you should use your own startup scripts vs this helper function.
#'
#' @param tag Splash Docker image tag to start
#' @note you need Docker running on your system and have pulled the container with
#'       [install_splash] for this to work. You should save the resultant
#'       object for use in [stop_splash] otherwise you'll have to kill it from the
#'       command line interface.
#' @param container_name naem for the container. Defaults to "`splashr`".
#' @param remove remove the Splash container instance after it's stopped?
#'        Defaults to `FALSE`.
#' @param ... passed on to Splash instance launch parameters
#' @family splash_docker_helpers
#' @return `stevedore` container object
#' @export
#' @examples \dontrun{
#' install_splash()
#' splash_container <- start_splash()
#' stop_splash(splash_container)
#' }
start_splash <- function(tag="latest", container_name = "splashr", remove=FALSE, ...) {

  docker <- stevedore::docker_client()

  tryCatch(
    docker$container$run(
      image = sprintf("scrapinghub/splash:%s", tag),
      name = container_name,
      ports = c("5023:5023", "8051:8051", "8050:8050"),
      detach = TRUE,
      rm = remove,
      tty = TRUE,
      "--disable-browser-caches",
      ...
    ),
    error = function(e) {
      message("Error pulling image from DockerHub.")
      return(NULL)
    },
    interrupt = function(e) {
      stop("Terminated by user", call. = FALSE)
    }
  ) -> splash_inst

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
  if (inherits(splash_container, "stevedore_object")) {
    splash_container$stop()
    splash_container$remove()
  }
  invisible(NULL)
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

  docker <- stevedore::docker_client()

  x <- docker$container$list(all=TRUE)

  for (i in 1:nrow(x)) {
    if (grepl("bin/splash", x$command[i])) {
      message(sprintf("Pruning: %s...", x$id[i]))
      if (x$state[i] == "running") {
        cntnr <- docker$container$get(x$id[i])
        cntnr$stop()
        cntnr$remove()
      }
    }
  }

}


# @param add_tempdir This is `FALSE` initially since you could try to run
#   the splash image on a remote system. It has to be a local one for this to work.
#   If `TRUE` then a local temporary directory (made with [tempdir()])
#   will be added to the mount configuration for use with [render_file()]. You will need to
#       ensure the necessary system temp dirs are accessible as a mounts. For
#       macOS this means adding `/private` to said Docker config.
