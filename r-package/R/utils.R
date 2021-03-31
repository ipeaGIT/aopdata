############# Support functions for aop
# nocov start


#' Select city input
#'
#' @description Subsets the metadata table by 'city'.
#'
#' @param temp_meta A dataframe with the file_url addresses of aop datasets
#' @param city city input (passed from read_ function)
#'
#' @return A `data.frame` object with metadata subsetted by 'city'
#' @export
#' @family support functions
#'
select_city_input <- function(temp_meta=temp_meta, city=NULL){

  # NULL or numeric
  if(! is.character(city) ){stop(paste0("Error: Invalid Value to argument 'city'. It must be one of the following: ",
                                paste(unique(temp_meta$name_muni),collapse = " | "))) }

  # 3 letter-abbreviation
  if (nchar(city)[1]==3) {

      # valid input 'all'
      if (city %in% 'all'){ return(temp_meta) }

      # valid input
      if (city %in% temp_meta$city){ temp_meta <- temp_meta[ temp_meta$city %in% city, ]
                                  return(temp_meta) }


      # invalid input
      else { stop(paste0("Error: Invalid Value to argument 'city'. It must be one of the following: ",
                         paste(unique(temp_meta$city), collapse = " | "))) }
    }


  # full name
  if (nchar(city)[1]>3) {

    city <- tolower(city)
    city <- rm_accent(city)

    # valid input
    if (city %in% temp_meta$name_muni){ temp_meta <- temp_meta[ temp_meta$name_muni %in% city, ]
                                        return(temp_meta)
                                      }

    # invalid input
    else { stop(paste0("Error: Invalid Value to argument 'city'. It must be one of the following: ",
                       paste(unique(temp_meta$name_muni), collapse = " | "))) }
  }
}




#' Select year input
#'
#' @description Subsets the metadata table by 'year'.
#'
#' @param temp_meta A dataframe with the file_url addresses of aop datasets
#' @param year Year of the dataset (passed from read_ function)
#'
#' @return A `data.frame` object with metadata subsetted by 'year'
#' @export
#' @family support functions
#'
select_year_input <- function(temp_meta=temp_meta, year=NULL){

  # NULL
  if (is.null(year)){  stop(paste0("Error: Invalid Value to argument 'year'. It must be one of the following: ",
                                   paste(unique(temp_meta$year),collapse = " "))) }

  # invalid input
  else if (year %in% temp_meta$year){ message(paste0("Using year ", year))
                                  temp_meta <- temp_meta[ temp_meta$year %in% year, ]
                                  return(temp_meta) }

  # invalid input
  else { stop(paste0("Error: Invalid Value to argument 'year'. It must be one of the following: ",
                         paste(unique(temp_meta$year), collapse = " ")))
    }
}




#' Select mode input
#'
#' @description Subsets the metadata table by 'mode'.
#'
#' @param temp_meta A dataframe with the file_url addresses of aop datasets
#' @param mode Transport mode (passed by read_ function)
#'
#' @return A `data.frame` object with metadata subsetted by 'mode'
#' @export
#' @family support functions
#'
select_mode_input <- function(temp_meta=temp_meta, mode=NULL){

  # NULL
  if (is.null(mode)){  stop(paste0("Error: Invalid Value to argument 'mode'. It must be one of the following: ",
                                paste(unique(temp_meta$mode),collapse = " "))) }

  # invalid input
  else if (mode %in% temp_meta$mode){ message(paste0("Using mode ", mode))
    temp_meta <- temp_meta[ temp_meta$mode %in% mode, ]
    return(temp_meta) }

  # invalid input
  else { stop(paste0("Error: Invalid Value to argument 'mode'. It must be one of the following: ",
                     paste(unique(temp_meta$mode), collapse = " ")))
  }
}





#' Select metadata
#'
#' @description Subsets the metadata table by data 'type', 'city', 'year' and
#'              'mode'
#'
#' @param t Type of data: 'access' or 'grid' (passed from `read_` function)
#' @param c City (passed from `read_` function)
#' @param m Transport mode (passed from `read_` function)
#' @param y Year of the dataset (passed from `read_` function)
#'
#' @return A `data.frame` object with metadata subsetted by data type,
#'        'city', 'year' and 'mode'
#' @export
#' @family support functions
#' @examples \donttest{
#' df <- download_metadata()
#' }
select_metadata <- function(t=NULL, c=NULL, y=NULL, m=NULL){

# download metadata
  metadata <- as.data.frame(download_metadata())

  # Select data type
  temp_meta <- subset(metadata, type == t)

  # Select city input
  temp_meta <- select_city_input(temp_meta, city=c)

  # select year input
  if(t %in% c('access','landuse', 'land_use', 'population')){
    temp_meta <- select_year_input(temp_meta, year=y)
  }

  # select mode input
  if(t=='access'){
    temp_meta <- select_mode_input(temp_meta, mode=m)
    }

  return(temp_meta)
}




#' Download data to temporary directory.
#'
#' @description Save requested data (either an `sf` or a `data.frame`)
#'              to a temporary directory.
#'
#' @param file_url A string with the file_url address of a aop dataset
#' @param progress_bar Logical. Defaults to (TRUE) display progress bar
#'
#' @return No visible output. The downloaded file (either an `sf` or a
#'         `data.frame`) is saved to a temporary directory.
#' @export
#' @family support functions
#'
download_data <- function(file_url, progress_bar = showProgress){

  if( !(progress_bar %in% c(T, F)) ){ stop("Value to argument 'showProgress' has to be either TRUE or FALSE") }

## one single file

  if(length(file_url)==1 & progress_bar == TRUE){

    # test server connection
    check_connection(file_url[1])

    # download data
    temps <- paste0(tempdir(),"/", unlist(lapply(strsplit(file_url,"/"),tail,n=1L)))
    httr::GET(url=file_url, httr::progress(), httr::write_disk(temps, overwrite = T))

    # load data
    temp_data <- load_data(file_url, temps)
    return(temp_data)
    }

  else if(length(file_url)==1 & progress_bar == FALSE){

    # test server connection
    check_connection(file_url[1])

    # download data
    temps <- paste0(tempdir(),"/", unlist(lapply(strsplit(file_url,"/"),tail,n=1L)))
    httr::GET(url=file_url, httr::write_disk(temps, overwrite = T))

    # load data
    temp_data <- load_data(file_url, temps)
    return(temp_data)
  }

## multiple files

  else if(length(file_url) > 1 & progress_bar == TRUE) {

    # test server connection
    check_connection(file_url[1])

    # input for progress bar
    total <- length(file_url)
    pb <- utils::txtProgressBar(min = 0, max = total, style = 3)

    # download files
    lapply(X=file_url, function(x){
      i <- match(c(x),file_url)
      httr::GET(url=x, #httr::progress(),
                httr::write_disk(paste0(tempdir(),"/", unlist(lapply(strsplit(x,"/"),tail,n=1L))), overwrite = T))
      utils::setTxtProgressBar(pb, i)})

    # closing progress bar
    close(pb)

    # load data
    temp_data <- load_data(file_url)
    return(temp_data)
    }

  else if(length(file_url) > 1 & progress_bar == FALSE) {

    # test server connection
    check_connection(file_url[1])

    # download data
    lapply(X=file_url, function(x){
      i <- match(c(x),file_url)
      httr::GET(url=x, #httr::progress(),
                httr::write_disk(paste0(tempdir(),"/", unlist(lapply(strsplit(x,"/"),tail,n=1L))), overwrite = T))})

    # load data
    temp_data <- load_data(file_url)
    return(temp_data)
    }
}




#' Load data from tempdir to global environment
#'
#' @description Reads data from tempdir to global environment.
#'
#' @param file_url A string with the file_url address of a aop dataset
#' @param temps The address of a data file stored in tempdir. Defaults to NULL
#'
#' @return Returns either an `sf` or a `data.frame`, dependeding of the data set
#'         that was downloaded
#' @export
#' @family support functions
#'
load_data <- function(file_url, temps=NULL){

  # check if .csv or geopackage
  if( file_url[1] %like% '.csv' ){ fformat<- 'csv'}
  if( file_url[1] %like% '.gpkg' ){ fformat<- 'gpkg'}

  ### one single file
  if(length(file_url)==1){

    # read file
    if( fformat=='csv' ){ temp <- data.table::fread(temps) }
    if( fformat=='gpkg' ){ temp <- sf::st_read(temps, quiet=T) }
    return(temp)
  }

  else if(length(file_url) > 1){

    # read files and pile them up
    files <- unlist(lapply(strsplit(file_url,"/"), tail, n = 1L))
    files <- paste0(tempdir(),"/",files)

    # access csv
    if( fformat=='csv' ){
      files <- lapply(X=files, FUN= data.table::fread)
      temp <- data.table::rbindlist(files, fill = TRUE)
    }

    # grid geopackage
    if( fformat=='gpkg' ){
      files <- lapply(X=files, FUN= sf::st_read, quiet=T)
      temp <- sf::st_as_sf(data.table::rbindlist(files, fill = TRUE))
    }

    return(temp)
  }

  # load data to memory
  temp_data <- load_data(file_url, temps)
  return(temp_data)
}




#' Remove accents from string
#'
#' @description Removes non-ASCII characters from a string.
#'
#' @param str A string
#' @param pattern A pattern
#'
#' @return Returns a string with non-ASCII characters replaced with "\'uxxxx" escapes
#'
#' @export
#' @family support functions
#'
rm_accent <- function(str, pattern="all") {
  if(!is.character(str))
    str <- as.character(str)
  pattern <- unique(pattern)
  if(any(pattern=="\u00c7"))
    pattern[pattern=="\u00c7"] <- "\u00e7"
  symbols <- c(
    acute = "\u00e1\u00e9\u00ed\u00f3\u00fa\u00c1\u00c9\u00cd\u00d3\u00da\u00fd\u00dd",
    grave = "\u00e0\u00e8\u00ec\u00f2\u00f9\u00c0\u00c8\u00cc\u00d2\u00d9",
    circunflex = "\u00e2\u00ea\u00ee\u00f4\u00fb\u00c2\u00ca\u00ce\u00d4\u00db",
    tilde = "\u00e3\u00f5\u00c3\u00d5\u00f1\u00d1",
    umlaut = "\u00e4\u00eb\u00ef\u00f6\u00fc\u00c4\u00cb\u00cf\u00d6\u00dc\u00ff",
    cedil = "\u00e7\u00c7"
  )
  nudeSymbols <- c(
    acute = "aeiouAEIOUyY",
    grave = "aeiouAEIOU",
    circunflex = "aeiouAEIOU",
    tilde = "aoAOnN",
    umlaut = "aeiouAEIOUy",
    cedil = "cC"
  )
  accentTypes <- c("\u00b4", "`", "^", "~", "\u00a8", "\u00e7") # c("´","`","^","~","¨","ç")
  if(any(c("all","al","a","todos","t","to","tod","todo")%in%pattern))
    return(chartr(paste(symbols, collapse=""), paste(nudeSymbols, collapse=""), str))
  for(i in which(accentTypes%in%pattern))
    str <- chartr(symbols[i],nudeSymbols[i], str)
  return(str)
}




#' Spatial join of AOP data
#'
#' @description Merges landuse or access data with H3 grid geometries
#'
#' @param aop_df A `data.frame` of aop data
#' @param aop_sf A spatial `sf` of aop data
#'
#' @return Returns a `data.frame sf` with access/landuse data and grid geometries
#' @export
#' @family support functions
#'
aop_spatial_join <- function(aop_df, aop_sf){

  data.table::setDT(aop_df)
  data.table::setDT(aop_sf)
  data.table::setkeyv(aop_df, c('abbrev_muni', 'name_muni', 'code_muni', 'id_hex'))

  # merge
    # slower # aop <- data.table::merge.data.table(aop_df, aop_sf, by = 'id_hex')
    aop_df[aop_sf, on = 'id_hex', geometry := i.geom]

  # back to sf
  aop <- sf::st_sf(aop_df)

  return(aop)

  }




#' Merge land use and access data
#'
#' @description Merges landuse and access data
#'
#' @param aop_landuse A `data.table` of aop land use data
#' @param aop_access A `data.table` of aop access data
#'
#' @return Returns a `data.table` with landuse and access data
#' @export
#' @family support functions
#'
aop_merge <- function(aop_landuse, aop_access){

  data.table::setDT(aop_landuse)
  data.table::setDT(aop_access)
  data.table::setkeyv(aop_landuse, c('abbrev_muni', 'name_muni', 'code_muni', 'id_hex'))
  data.table::setkeyv(aop_access, c('abbrev_muni', 'name_muni', 'code_muni', 'id_hex'))

  # merge
  aop <- data.table::merge.data.table(aop_landuse, aop_access, by = c('abbrev_muni', 'name_muni', 'code_muni', 'id_hex'), all = TRUE)

  return(aop)
}




#' Check internet connection with Ipea server
#'
#' @description
#' Checks if there is internet connection to Ipea server to download aop data.
#'
#' @param file_url A string with the file_url address of an aop dataset
#'
#' @return Logic `TRUE or `FALSE`.
#'
#' @export
#' @family support functions
#'
check_connection <- function(file_url = 'https://www.ipea.gov.br/geobr/aopdata/metadata/metadata.csv'){

  # check internet connection
  if (!curl::has_internet()) {
    message("No internet connection.")
    return(invisible(NULL))
  }

  # test server connection
    # crul::ok(file_url)
  if (httr::http_error(httr::GET(file_url))) {
    message("Problem connecting to data server. Please try aopdata again in a few minutes.")
    return(invisible(NULL))
    }
}

# #' Fail gracefully if Ipea server is not available
# #'
# #' The function allows to fail gracefully with an informative message
# #' if the Wikisource resource is not available (and not give a check warning nor error).
# #'
# #' @details See full discussion to be compliante with the CRAN policy
# #' <https://community.rstudio.com/t/internet-resources-should-fail-gracefully/49199>
# #'
# #' @param file_url A remote URL.
# #' @return Message.
# #'
# #' @export
# #' @family support functions
# #'
# gracefully_fail <- function(file_url = 'https://www.ipea.gov.br/geobr/aopdata/metadata/metadata.csv') {
#   try_GET <- function(x, ...) {
#     tryCatch(
#       httr::GET(url = x, httr::timeout(600), ...), #timeout 10 minutes
#       error = function(e) conditionMessage(e),
#       warning = function(w) conditionMessage(w)
#     )
#   }
#   is_response <- function(x) {
#     class(x) == "response"
#   }
#
#   # First check internet connection
#   if (!curl::has_internet()) {
#     message("No internet connection.")
#     return(invisible(NULL))
#   }
#   # Then try for timeout problems
#   resp <- try_GET(file_url)
#   if (!is_response(resp)) {
#     message(resp)
#     return(invisible(NULL))
#   }
#   # Then stop if status > 400
#   if (httr::http_error(resp)) {
#     httr::message_for_status(resp)
#     return(invisible(NULL))
#   }
#
# }


# nocov end
