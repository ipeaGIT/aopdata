#' Download accessibility estimates, population and land use data
#'
#' @description
#' Download annual estimates of access to employment, health and education
#' services by transport mode, as well as data on the spatial distribution of
#' population, schools and healthcare facilities at a fine spatial resolution
#' for all cities included in the study.
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
#' bho <- read_access(city = 'Belo Horizonte', mode = 'walk', year = 2019)
#' bho <- read_access(city = 'bho', mode = 'walk', year = 2019)
#'
#' # Read accessibility estimates for all cities
#' all <- read_access(city = 'all', mode = 'public_transport', year = 2019)
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
  aop_df <- download_data(file_url, progress_bar = showProgress)

  # peak Vs off-peak
  if(peak==TRUE){
                 aop_df <- subset(aop_df, peak == 1)
                } else {
                 aop_df <- subset(aop_df, peak == 0)
                }

  # with Vs without spatial data
  if(geometry == FALSE){
                        # return df
                        return(aop_df)

                        } else {

                        # return sf
                        aop_sf <- read_grid(city=city, showProgress=showProgress)
                        aop <- aop_spatial_join(aop_df, aop_sf)
                        return(aop)
                        }
  }
