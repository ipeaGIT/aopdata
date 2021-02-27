#' Download accessibility estimates
#'
#' @description
#' Download accessibility estimates
#'
#' @param city A city name or three-letter abbreviation
#' @param mode A transport mode.
#' @param year A date number in YYYY format.
#' @param geometry if FALSE (the default), returns a regular data.table of aop
#'                 data. if TRUE, returns a an `sf data.frame` with simple
#'                 feature geometry of spatial hexagonal grid H3.
#' @param showProgress Logical. Defaults to `TRUE` display progress bar
#'
#' @return A `data.frame` object
#'
#' @export
#' @family accessibility data functions
#' @examples \donttest{
#' # Read accessibility estimates of a single city
#' bho <- read_access(city = 'Belo Horizonte', mode = 'walk', year = 2019)
#' bho <- read_access(city = 'bho', mode = 'walk', year = 2019)
#'
#'}
read_access <- function(city, mode, year, geometry = FALSE, showProgress=TRUE){

  # Get metadata with data url addresses
  temp_meta <- select_metadata(t='access',
                               c=city,
                               y=year,
                               m=mode)

  # list paths of files to download
  file_url <- as.character(temp_meta$download_path)

  # download files
  aop_df <- download_gpkg(file_url, progress_bar = showProgress)

  # without spatial data
  if(geometry == FALSE){return(aop_df)}

  # with spatial data
  if(geometry == TRUE){

    aop_sf <- read_grid(city=city, showProgress=showProgress)
    aop <- aop_spatial_join(aop_df, aop_sf)
    return(aop)

    }
}
