#' Download accessibility estimates
#'
#' @description
#' Download accessibility estimates
#'
#' @param city A city name or three-letter abbreviation
#' @param mode A transport mode.
#' @param year A date number in YYYY format.
#' @param showProgress Logical. Defaults to `TRUE` display progress bar
#'
#' @return A `data.frame` object
#'
#' @export
#' @family accessibility data functions
#' @examples \donttest{
#' # Read accessibility estimates of a single city
#' spo <- read_access(city = 'sao paulo', mode = 'walk', year = 2019)
#'
#' # Read accessibility estimates of all cities in the project
#' spo <- read_access(city = 'all', mode = 'public_transport', year = 2019)
#'}
read_access <- function(city, mode, year=2019, showProgress=TRUE){

  # Get metadata with data url addresses
  temp_meta <- select_metadata(t='access',
                               c=city,
                               m=mode,
                               y=year)

  # list paths of files to download
  file_url <- as.character(temp_meta$download_path)

  # download files
  temp_sf <- download_gpkg(file_url, progress_bar = showProgress)
  return(temp_sf)
}
