# Less cool counterparts to purrr's side-effect capture-rs
#
# Most of the helper functions are 100% from output.R in purrr repo
#
# @param quiet Hide errors (`TRUE`, the default), or display them
#   as they occur?
# @param otherwise Default value to use when an error occurs.
#
# @return `safely`: wrapped function instead returns a list with
#   components `result` and `error`. One value is always `NULL`.
#
#   `quietly`: wrapped function instead returns a list with components
#   `result`, `output`, `messages` and `warnings`.
#
#   `possibly`: wrapped function uses a default value (`otherwise`)
#   whenever an error occurs.
safely <- function(.f, otherwise = NULL, quiet = TRUE) {
  function(...) capture_error(.f(...), otherwise, quiet)
}

quietly <- function(.f) {
  function(...) capture_output(.f(...))
}

possibly <- function(.f, otherwise, quiet = TRUE) {
  force(otherwise)
  function(...) {
    tryCatch(.f(...),
      error = function(e) {
        if (!quiet)
          message("Error: ", e$message)
        otherwise
      },
      interrupt = function(e) {
        stop("Terminated by user", call. = FALSE)
      }
    )
  }
}

capture_error <- function(code, otherwise = NULL, quiet = TRUE) {
  tryCatch(
    list(result = code, error = NULL),
    error = function(e) {
      if (!quiet)
        message("Error: ", e$message)

      list(result = otherwise, error = e)
    },
    interrupt = function(e) {
      stop("Terminated by user", call. = FALSE)
    }
  )
}

capture_output <- function(code) {
  warnings <- character()
  wHandler <- function(w) {
    warnings <<- c(warnings, w$message)
    invokeRestart("muffleWarning")
  }

  messages <- character()
  mHandler <- function(m) {
    messages <<- c(messages, m$message)
    invokeRestart("muffleMessage")
  }

  temp <- file()
  sink(temp)
  on.exit({
    sink()
    close(temp)
  })

  result <- withCallingHandlers(
    code,
    warning = wHandler,
    message = mHandler
  )

  output <- paste0(readLines(temp, warn = FALSE), collapse = "\n")

  list(
    result = result,
    output = output,
    warnings = warnings,
    messages = messages
  )
}
