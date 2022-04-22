#' Download accessibility estimates with population and land use data
#'
#' @description
#' Download annual estimates of access to employment, health, and education
#' services by transport mode and time of the day. See documentation 'Details'
#' for the data dictionary. The data comes aggregated on a hexagonal grid-based
#' on the global H3 index at resolution 9, with a size of 357 meters (short
#' diagonal) and an area of 0.74 km2. More information about H3 at
#' \url{https://h3geo.org/docs/core-library/restable/}.
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
#' @details
#' # Data dictionary:
#' The name of the columns with accessibility estimates are the
#' junction of three components: 1) Indicator 2) Type of opportunity
#' 3) Time thresold (if applicable)
#'
#' ## 1) Indicator
#' |**Indicator**|**Description**|**Note**|
#' |-----|-----|-----|
#' |`CMA`| Cumulative opportunity measure (active) |  |
#' |`TMI`| Travel time to closest opportunity | Value = Inf when travel time is longer than 2h (public transport) or 1,5h (walking or bicycle) |
#'
#' ## 2) Type of opportunity
#' |**Indicator**|**Description**|**Note**|
#' |-----|-----|-----|
#' | `TT`	| All jobs | |
#' | `TQ`	| Total jobs with partial match between job education and income quintile | |
#' | `TD`	| Total jobs with partial match between job education and income decile | |
#' | `ST`	| All healthcare facilities | |
#' | `SB`	| Healthcare facilities - Low complexity | |
#' | `SM`	| Healthcare facilities - Medium complexity | |
#' | `SA`	| Healthcare facilities - High complexity | |
#' | `ET`	| All public schools | |
#' | `EI`	| Public schools - early childhood | |
#' | `EF`	| Public schools - elementary schools | |
#' | `EM`	| Public schools - high schools | |
#'
#' ## 3) Time thresold (only applicable to CMA estimates)
#' | **Time thresold**|**Description**|**Note - Only applicable to:**|
#' |-----|-----|-----|
#' | `15`| Opportunities accessible within 15 min.	| Active transport modes |
#' | `30`| Opportunities accessible within 30 min.	| All transport modes |
#' | `45`| Opportunities accessible within 45 min.	| Active transport modes |
#' | `60`| Opportunities accessible within 60 min.	| All transport modes |
#' | `90`| Opportunities accessible within 90 min.	| Public transport |
#' |`120`| Opportunities accessible within 120 min.| Public transport |
#'
#'## 4) Cities available
#' |**City name**| **Three-letter abbreviation**|**Transport modes**|
#' |-----|-----|-----|
#' | Belem | `bel` | Active |
#' | Belo Horizonte | `bho` | All |
#' | Brasilia  | `bsb`| Active |
#' | Campinas  | `cam` | Active |
#' | Campo Grande | `cgr` | Active |
#' | Curitiba | `cur`| Active |
#' | Duque de Caxias | `duq` | Active |
#' | Fortaleza | `for`| All |
#' | Goiania  | `goi` | Active |
#' | Guarulhos  | `gua`| Active |
#' | Maceio  | `mac`| Active |
#' | Manaus  | `man`| Active |
#' | Natal  | `nat`| Active |
#' | Porto Alegre | `poa`| All |
#' | Recife | `rec` | All |
#' | Rio de Janeiro  | `rio`| All |
#' | Salvador  | `sal`| Active |
#' | Sao Goncalo  | `sgo`| Active |
#' | Sao Luis  | `slz`| Active |
#' | Sao Paulo  | `spo`| All |
#'
#' @export
#' @family accessibility data functions
#' @examples \dontrun{ if (interactive()) {
#' # Read accessibility estimates of a single city
#' df <- read_access(city = 'Fortaleza', mode = 'public_transport', year = 2019, showProgress = FALSE)
#' df <- read_access(city = 'Goiania', mode = 'public_transport', year = 2019, showProgress = FALSE)
#'
#' # Read accessibility estimates for all cities
#' all <- read_access(city = 'all', mode = 'walk', year = 2019, showProgress = FALSE)
#'}}

read_access <- function(city=NULL, mode = 'walk', peak = TRUE, year = 2019, geometry = FALSE, showProgress = TRUE){

  # checks
  if(! is.logical(geometry) ){stop("The 'geometry' argument must either be TRUE or FALSE")}
  if(! is.logical(showProgress) ){stop("The 'showProgress' argument must either be TRUE or FALSE")}
  if(! is.logical(peak) ){stop("The 'peak' argument must either be TRUE or FALSE")}

  # Get metadata with data url addresses
  temp_meta <- select_metadata(t='access',
                               c=city,
                               y=year,
                               m=mode)

  # check if download failed
  if (is.null(temp_meta)) { return(invisible(NULL)) }

  message(paste0("Downloading accessibility data for the year ", year))

  # list paths of files to download
  file_url <- as.character(temp_meta$download_path)

  # download files
  aop_access <- download_data(file_url, progress_bar = showProgress)

  # check if download failed
  if (is.null(aop_access)) { return(invisible(NULL)) }

  # peak Vs off-peak
    city <- tolower(city)
    # remove accents
    city <- base::iconv(city, to="ASCII//TRANSLIT")


  cities_with_pt <- ( all(city %in% c('for', 'rec', 'bho', 'rio', 'spo', 'cur', 'poa', 'goi')) |
                    all(city %in% c('fortaleza', 'recife', 'belo horizonte',
                                'rio de janeiro', 'sao paulo', 'curitiba', 'porto alegre', 'goiania')) )

  if (isFALSE(cities_with_pt) & mode == 'public_transport') {stop("One of the selected cities does not have public transport data for that year.")}

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
