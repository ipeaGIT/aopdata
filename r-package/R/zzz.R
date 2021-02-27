# nocov start
utils::globalVariables(c(".", ":="))

.onLoad = function(lib, pkg) {
  requireNamespace("sf")
  requireNamespace("data.table")
}


#' @importFrom data.table setDT :=
#' @importFrom utils head tail
NULL


## quiets concerns of R CMD check re: the .'s that appear in pipelines
if(getRversion() >= "2.15.1") utils::globalVariables(
  c('geometry', 'i.geom', 'showProgress', 'type'))




# nocov end
