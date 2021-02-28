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
#' @param year Numeric. A year number in YYYY format. Default set to 2019, the
#'             only year currently available.
#' @param geometry Logical. if FALSE (the default), returns a regular data.table
#'                 of aop data. if TRUE, returns a an `sf data.frame` with simple
#'                 feature geometry of spatial hexagonal grid H3. See details in
#'                 \link{read_grid}.
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
#' # Read accessibility estimates for all cities
#' all <- read_access(city = 'all', mode = 'public_transport', year = 2019)

#'}
read_access <- function(city, mode = 'walk', year = 2019, geometry = FALSE, showProgress = TRUE){

  # Get metadata with data url addresses
  temp_meta <- select_metadata(t='access',
                               c=city,
                               y=year,
                               m=mode)

  # list paths of files to download
  file_url <- as.character(temp_meta$download_path)

  # download files
  aop_df <- download_data(file_url, progress_bar = showProgress)

  # without spatial data, return df
  if(geometry == FALSE){
                        return(aop_df)
                        }

  # with spatial data, return sf
  if(geometry == TRUE){
                        aop_sf <- read_grid(city=city, showProgress=showProgress)
                        aop <- aop_spatial_join(aop_df, aop_sf)
                        return(aop)
                        }
}
