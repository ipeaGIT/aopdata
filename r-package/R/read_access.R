#' Download accessibility estimates
#'
#' @description
#' Download annual estimates of access to employment, health and education
#' services by transport mode and time of the day
#'
#' @param city Character. A city name or three-letter abbreviation. If
#'             `city="all"`, results for all cities are loaded.
#' @param mode Character. A transport mode. Modes available include
#'             'public_transport', 'bicycle', or 'walk' (the default).
#' @param peak Logical. If `TRUE` (the default), returns accessibility estimates
#'             during peak time, between 6am and 8am. If `FALSE`, returns
#'             accessibility during off-peak, between 2pm and 4am. This argument
#'             only takes effect when `mode = public_transport`.
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
#' @family accessibility data functions
#' @examples
#' # Read accessibility estimates of a single city
#' df <- read_access(city = 'Fortaleza', mode = 'walk', year = 2019, showProgress = FALSE)
#' df <- read_access(city = 'for', mode = 'walk', year = 2019, showProgress = FALSE)
#'
#' # Read accessibility estimates for all cities
#' # all <- read_access(city = 'all', mode = 'public_transport', year = 2019)
#'
read_access <- function(city, mode = 'walk', peak = TRUE, year = 2019, geometry = FALSE, showProgress = TRUE){

  # Get metadata with data url addresses
  temp_meta <- select_metadata(t='access',
                               c=city,
                               y=year,
                               m=mode)

  # list paths of files to download
  file_url <- as.character(temp_meta$download_path)

  # download files
  aop_access <- download_data(file_url, progress_bar = showProgress)

  # peak Vs off-peak
  cities_with_pt <- (city %in% c('for', 'rec', 'bho', 'rio', 'spo', 'cur', 'poa') |
                    city %in% c('Fortaleza', 'Recife', 'Belo Horizonte',
                                'Rio de Janeiro', 'S\u00e3o Paulo', 'Curitiba', 'Porto Alegre'))

  if(peak==FALSE & mode == 'public_transport' & cities_with_pt){
                  aop_access <- subset(aop_access, peak == 0)
                } else {
                  aop_access <- subset(aop_access, peak == 1)
                }

 # Download and merge land use data
  aop_landuse <- read_landuse(city=city, year=year, showProgress=showProgress)
  aop <- aop_merge(aop_landuse, aop_access)

  # with Vs without spatial data
  if(geometry == FALSE){
                        # return df
                        return(aop)

                        } else {

                        # return sf
                        aop_grid <- read_grid(city=city, showProgress=showProgress)
                        aop_sf <- aop_spatial_join(aop, aop_grid)
                        return(aop_sf)
                        }
  }
