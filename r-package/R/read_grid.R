#' Download spatial hexagonal grid H3
#'
#' @description
#' Results of the AOP project are spatially aggregated on a hexagonal grid based
#' on the global H3 index at resolution 8, with a size of 357 meters (short
#' diagonal) and an area of 0.74 km2. More infor about H3 at
#' \url{https://h3geo.org/docs/core-library/restable/}.  See documentation
#' 'Details' for the data dictionary.
#'
#' @param city Character. A city name or three-letter abbreviation. If
#'             `city="all"`, results for all cities are loaded.
#' @param showProgress Logical. Defaults to `TRUE` display progress bar
#'
#' @return An `sf data.frame` object
#' @details
#' # Data dictionary:
#' |**Data type**|**column**|**Description**|
#' |-----|-----|-----|
#' | geographic	| `abbrev_muni`| Abbreviation of city name (3 letters)	|
#' | geographic	| `name_muni`  | City name	|
#' | geographic	| `code_muni`	 | 7-digit code of each city	| |
#' | geographic	| `id_hex`	   | Unique id of hexagonal cell	|
#'
#' @export
#' @family spatial data functions
#' @examples
#' # Read spatial grid of a single city
#' nat <- read_grid(city = 'Natal', showProgress = FALSE)
#'
#' # Read spatial grid of all cities in the project
#' # all <- read_grid(city = 'all')
#'
read_grid <- function(city, showProgress = TRUE){

  # Get metadata with data url addresses
  temp_meta <- select_metadata(t="grid", c=city)

  # list paths of files to download
  file_url <- as.character(temp_meta$download_path)

  # download files
  aop_sf <- download_data(file_url, progress_bar = showProgress)
  return(aop_sf)
}
