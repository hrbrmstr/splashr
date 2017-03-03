trunc_string <- function (x, maxlen = 20, justify = "left")  {
  toolong <- nzchar(x) > maxlen
  maxwidth <- ifelse(toolong, maxlen - 3, maxlen)
  chopx <- substr(x, 1, maxwidth)
  lenx <- length(x)
  for (i in 1:length(x)) if (toolong[i]) chopx[i] <- paste(chopx[i], "...", sep = "")
  return(formatC(chopx, width = maxlen, flag = ifelse(justify == "left", "-", " ")))
}

parse_query <- function(query) {
  params <- vapply(stri_split_regex(query, "&", omit_empty=TRUE)[[1]],
                   stri_split_fixed, "=", 2, simplify=TRUE,
                   FUN.VALUE=character(2))
  purrr::set_names(as.list(curl::curl_unescape(params[2,])),
                   curl::curl_unescape(params[1,]))
}

check_wait <- function(wait) {
  if (wait<0) {
    message("The 'wait' parameter cannot be less than 0; auto-changing it to 0")
    wait <- 0
  } else if (wait>10) {
    message("The 'wait' parameter cannot be greater than 10 in render_... calls; auto-changing it to 10")
    message("Use the direct lua interface or lua DSL wrapper functions to set higher 'wait' vales.")
    wait <- 10
  }
  wait
}