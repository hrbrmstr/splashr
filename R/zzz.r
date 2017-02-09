.pkgenv <- new.env(parent=emptyenv())

.onAttach <- function(...) {
  temp_dir <- normalizePath(gsub("//", "/", path.expand(tempdir())))
  assign("temp_dir", temp_dir, envir=.pkgenv)
}