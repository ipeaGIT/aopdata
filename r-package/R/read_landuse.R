#' Download land use and population data
#'
#' @description
#' Download data on the spatial distribution of population, schools and
#' healthcare facilities at a fine spatial resolution for cities included in the
#' study. The data comes aggregated on a hexagonal grid based on the global H3
#' index at resolution 9, with a size of 357 meters (short diagonal) and an area
#' of 0.74 km2. More information about H3 at \url{https://h3geo.org/docs/core-library/restable/}.
#'
#' See documentation 'Details' for the data dictionary.
#'
#' @param city Character. A city name or three-letter abbreviation. If
#'             `city="all"`, results for all cities are loaded.
#' @param year Numeric. A year number in YYYY format. Default set to 2019, the
#'             only year currently available.
#' @param geometry Logical. If `FALSE` (the default), returns a regular data.table
#'                 of aop data. If `TRUE`, returns a `sf data.frame` with simple
#'                 feature geometry of spatial hexagonal grid H3. See details in
#'                 \link{read_grid}.
#' @param showProgress Logical. Defaults to `TRUE` display progress bar
#'
#' @return A `data.frame` object or an `sf data.frame` object
#'
#' @details
#' # Data dictionary:
#' |**Data type**|**column**|**Description**|**Value**|
#' |-----|-----|-----|-----|
#' | geographic	| `abbrev_muni`|	Abbreviation of city name (3 letters)	| |
#' | geographic	| `name_muni`  | City name	| |
#' | geographic	| `code_muni`	 | 7-digit code of each city	| |
#' | geographic	| `id_hex`	   | Unique id of hexagonal cell	| |
#' | sociodemographic | `P001` | Total number of residents	| |
#' | sociodemographic | `P002` | Number of white residents	| |
#' | sociodemographic | `P003` | Number of black residents	| |
#' | sociodemographic | `P004` | Number of indiginous residents | |
#' | sociodemographic | `P005` | Number of asian-descendents residents | |
#' | sociodemographic | `R001` | Average household income per capita	| R$ (Brazilian Reais), values in 2010 |
#' | sociodemographic | `R002` | Income quintile group	| 1 (poorest), 2, 3, 4, 5 (richest) |
#' | sociodemographic | `R003` | Income decile group	| 1 (poorest), 2, 3, 4, 5, 6, 7, 8, 9, 10 (richest) |
#' | land use         |	`T001` | Total number of formal jobs | |
#' | land use         |	`T002` | Total number of formal jobs with primary education | |
#' | land use         |	`T003` | Number of formal jobs with secundary education | |
#' | land use         |	`T004` | Number of formal jobs with tertiary education | |
#' | land use         |	`E001` | Total number of public schools | |
#' | land use         |	`E002` | Number of public schools - early childhood | |
#' | land use         |	`E003` | Number of public schools - elementary schools | |
#' | land use         |	`E004` | Number of public schools - high schools | |
#' | land use         |	`S001` | Total number of healthcare facilities | |
#' | land use         |	`S002` | Number of healthcare facilities - low complexity | |
#' | land use         |	`S003` | Number of healthcare facilities - medium complexity | |
#' | land use         |	`S004` | Number of healthcare facilities - high complexity | |
#'
#' # Cities available
#' |**City name**| **Three-letter abbreviation**|
#' |-----|-----|
#' | Belem | `bel` |
#' | Belo Horizonte | `bho` |
#' | Brasilia  | `bsb`|
#' | Campinas  | `cam` |
#' | Campo Grande | `cgr` |
#' | Curitiba | `cur`|
#' | Duque de Caxias | `duq` |
#' | Fortaleza | `for`|
#' | Goiania  | `goi` |
#' | Guarulhos  | `gua`|
#' | Maceio  | `mac`|
#' | Manaus  | `man`|
#' | Natal  | `nat`|
#' | Porto Alegre | `poa`|
#' | Recife | `rec` |
#' | Rio de Janeiro  | `rio`|
#' | Salvador  | `sal`|
#' | Sao Goncalo  | `sgo`|
#' | Sao Luis  | `slz`|
#' | Sao Paulo  | `spo`|
#' 
#' @export
#' @family land use data functions
#' @examples \dontrun{ if (interactive()) {
#' # a single city
#' bho <- read_landuse(city = 'Belo Horizonte', year = 2019, showProgress = FALSE)
#' bho <- read_landuse(city = 'bho', year = 2019, showProgress = FALSE)
#'
#' # all cities
#' all <- read_landuse(city = 'all', year = 2019)
#'}}
read_landuse <- function(city=NULL, year = 2019, geometry = FALSE, showProgress = TRUE){

  # checks
  if(! is.logical(geometry) ){stop("The 'geometry' argument must either be TRUE or FALSE")}
  if(! is.logical(showProgress) ){stop("The 'showProgress' argument must either be TRUE or FALSE")}

  # Get metadata with data url addresses
  temp_meta <- select_metadata(t='land_use',
                               c=city,
                               y=year)

  # check if download failed
  if (is.null(temp_meta)) { return(invisible(NULL)) }

  message(paste0("Downloading land use data from the year ", year))

  # list paths of files to download
  file_url <- as.character(temp_meta$download_path)

  # download files
  aop_landuse <- download_data(file_url, progress_bar = showProgress)

  # check if download failed
  if (is.null(aop_landuse)) { return(invisible(NULL)) }

  # Download and merge population data
  aop_population <- read_population(city=city, showProgress = showProgress)
  aop <- data.table::merge.data.table(aop_population, aop_landuse, by = c('year', 'abbrev_muni', 'name_muni', 'code_muni', 'id_hex'), all = TRUE)

  # with Vs without spatial data
  if(geometry == FALSE){
                        # return df
                        return(aop)

                        } else {

                        # return sf
                        aop_grid <- read_grid(city=city, showProgress=showProgress)

                        # create function aop_join to bring in land use info
                        aop_sf <- aop_spatial_join(aop, aop_grid)
                        return(aop_sf)
                        }
  }
