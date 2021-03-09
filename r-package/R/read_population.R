#' Download population and socioeconomic data
#'
#' @description
#' Download population and socioeconomic data from the Brazilian Census aggregated
#' on a hexagonal grid based on the global H3 index at resolution 8, with a size of
#' 357 meters (short diagonal) and an area of 0.74 km2. More information about H3 at
#' \url{https://h3geo.org/docs/core-library/restable/}.
#'
#' @param city Character. A city name or three-letter abbreviation. If
#'             `city="all"`, results for all cities are loaded.
#' @param year Numeric. A year number in YYYY format. Default set to 2019, the
#'             only year currently available.
#' @param geometry Logical. If `FALSE` (the default), returns a regular data.table
#'                 of aop data. If `TRUE`, returns a an `sf data.frame` with simple
#'                 feature geometry of spatial hexagonal grid H3. See details in
#'                 \link{read_grid}.
#' @param showProgress Logical. Defaults to `TRUE` display progress bar
#'
#' @return A `data.frame` object or an `sf data.frame` object
#'
#' @export
#' @family population data functions
#' @examples \donttest{
#' # a single city
#' bho <- read_population(city = 'Belo Horizonte', year = 2010)
#' bho <- read_population(city = 'bho', year = 2010)
#'
#' # all cities
#' all <- read_population(city = 'all', year = 2010)

#'}
read_landuse <- function(city='bel', year = 2010, geometry = FALSE, showProgress = TRUE){

  # Get metadata with data url addresses
  temp_meta <- select_metadata(t='population',
                               c=city,
                               y=year)

  # list paths of files to download
  file_url <- as.character(temp_meta$download_path)

  # download files
  aop_landuse <- download_data(file_url, progress_bar = showProgress)

  # with Vs without spatial data
  if(geometry == FALSE){
                        # return df
                        return(aop_landuse)

                        } else {

                        # return sf
                        aop_grid <- read_grid(city=city, showProgress=showProgress)

                        # create function aop_join to bring in land use info
                        aop_sf <- aop_spatial_join(aop_landuse, aop_grid)
                        return(aop_sf)
                        }
  }
