check_or_report_status <- function(res) {

  if (httr::status_code(res) >= 400) {
    msg <- httr::content(res, as="text", encoding="UTF-8")
    msg <- jsonlite::fromJSON(msg)
    httr::stop_for_status(
      x = res,
      task = sprintf(
        fmt = "render due to %s",
        paste0(c(msg[["type"]], msg[["description"]], msg[["info"]]), collapse="; ")
      )
    )
  }

}
