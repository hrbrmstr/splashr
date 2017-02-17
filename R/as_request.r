#' Return a HAR entry response as an httr::response object
#'
#' @param har_entry a HAR object (should contain a response body to be most useful)
#' @export
#' @examples \dontrun{
#' library(purrr)
#'
#' URL <- "http://www.svs.cl/portal/principal/605/w3-propertyvalue-18554.html"
#'
#' splash_local %>%
#'   splash_response_body(TRUE) %>%
#'   splash_user_agent(ua_macos_chrome) %>%
#'   splash_go(URL) %>%
#'   splash_wait(2) %>%
#'   splash_har() -> har
#'
#' keep(har$log$entries, is_xhr) %>%
#'   map(as_request) %>%
#'   map(httr::content, as="parsed")
#' }
as_request <- function(har_entry) {

  if (length(har_entry$response$content$text) > 0) {
    content_body <- openssl::base64_decode(har_entry$response$content$text)
  } else {
    content_body <- NULL
  }

  structure(list(
    url = har_entry$request$url,
    status_code = har_entry$response$status,
    date = lubridate::ymd_hms(har_entry$startedDateTime),
    headers = setNames(map(har_entry$response$headers, "value"),
                       map(har_entry$response$headers, "name")) %>%
      insensitive(),
    content = content_body
  ), class="response")

}
