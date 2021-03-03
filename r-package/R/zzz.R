#' @importFrom data.table setDT := %like%
#' @importFrom utils head tail
NULL


## quiets concerns of R CMD check re: the .'s that appear in pipelines
if(getRversion() >= "2.15.1") utils::globalVariables(
  c('geometry', 'i.geom', 'showProgress', 'type', '.', ':=', '%like%'))
