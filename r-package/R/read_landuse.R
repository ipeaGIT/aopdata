#' Download population and land use data
#'
#' @description
#' Download data on the spatial distribution of population, schools and
#' healthcare facilities at a fine spatial resolution for cities included in the
#' study.
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
#' @return A `data.frame` object
#'
#' @export
#' @family land use data functions
#' @examples \donttest{
#' # a single city
#' bho <- read_landuse(city = 'Belo Horizonte', year = 2019)
#' bho <- read_landuse(city = 'bho', year = 2019)
#'
#' # all cities
#' all <- read_landuse(city = 'all', year = 2019)

#'}
read_landuse <- function(city='bel', year = 2019, geometry = FALSE, showProgress = TRUE){

  # Get metadata with data url addresses
  temp_meta <- select_metadata(t='landuse',
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
