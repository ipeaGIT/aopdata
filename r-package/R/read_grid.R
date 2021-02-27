#' Download spatial hexagonal grid
#'
#' @description
#' Download spatial hexagonal grid
#'
#' @param city A city name or three-letter abbreviation
#' @param showProgress Logical. Defaults to `TRUE` display progress bar
#'
#' @return An `sd data.frame` object
#'
#' @export
#' @family spatial grid data functions
#' @examples \donttest{
#' # Read spatial grid of a single city
#' nat <- read_grid(city = 'natal')
#' nat <- read_grid(city = 'nat')
#'
#' # Read spatial grid of all cities in the project
#' all <- read_grid(city = 'all')
#'}
read_grid <- function(city, showProgress=TRUE){

  # Get metadata with data url addresses
  temp_meta <- select_metadata(t="grid", c=city)

  # list paths of files to download
  file_url <- as.character(temp_meta$download_path)

  # download files
  aop_sf <- download_data(file_url, progress_bar = showProgress)
  return(aop_sf)
}
