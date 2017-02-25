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