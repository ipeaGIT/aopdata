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
read_population <- function(city='bel', year = 2010, geometry = FALSE, showProgress = TRUE){

  # Get metadata with data url addresses
  temp_meta <- select_metadata(t='population',
                               c=city,
                               y=year)

  # list paths of files to download
  file_url <- as.character(temp_meta$download_path)

  # download files
  aop_population <- download_data(file_url, progress_bar = showProgress)

  # with Vs without spatial data
  if(geometry == FALSE){
                        # return df
                        return(aop_population)

                        } else {

                        # return sf
                        aop_grid <- read_grid(city=city, showProgress=showProgress)

                        # create function aop_join to bring in land use info
                        aop_sf <- aop_spatial_join(aop_population, aop_grid)
                        return(aop_sf)
                        }
  }
