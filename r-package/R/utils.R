#' Select city input
#'
#' @description Subsets the metadata table by 'city'.
#'
#' @param temp_meta A data.frame with the url addresses of aop datasets
#' @param city city input (passed from read_ function)
#'
#' @return A `data.frame` object with metadata subsetted by 'city'
#' @keywords internal
#'
select_city_input <- function(temp_meta=temp_meta, city=NULL){

  # NULL or numeric
  if( !is.character(city) | any(nchar(city)<3) ){stop(paste0("Error: Invalid Value to argument 'city'. It must be one of the following: ",
                                paste(unique(temp_meta$name_muni),collapse = " | "))) }

  # 3 letter-abbreviation
  if (all(nchar(city)==3)) {

      # valid input 'all'
      if (any(city =='all')) { return(temp_meta) }

      # valid input
      if (all(city %in% temp_meta$city)) { temp_meta <- temp_meta[ temp_meta$city %in% city, ]
                                  return(temp_meta) }


      # invalid input
      else { stop(paste0("Error: Invalid Value to argument 'city'. It must be one of the following: ",
                         paste(unique(temp_meta$city), collapse = " | "))) }
    }


  # full name
  if (all(nchar(city)>3)) {

    city <- tolower(city)
    # remove accents
    city <- base::iconv(city, to="ASCII//TRANSLIT")

    # valid input
    if (all(city %in% temp_meta$name_muni)) { temp_meta <- temp_meta[ temp_meta$name_muni %in% city, ]
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
#' @param temp_meta A data.frame with the url addresses of aop datasets
#' @param year Year of the dataset (passed from read_ function)
#'
#' @return A `data.frame` object with metadata subsetted by 'year'
#' @keywords internal
#'
select_year_input <- function(temp_meta=temp_meta, year=NULL){

  checkmate::assert_numeric(year, finite = TRUE, any.missing = FALSE)

  # NULL
  if (is.null(year)){  stop(paste0("Error: Invalid Value to argument 'year'. It must be one of the following: ",
                                   paste(unique(temp_meta$year),collapse = " "))) }

  # invalid input
  else if (year %in% temp_meta$year) {
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
#' @param temp_meta A data.frame with the url addresses of aop datasets
#' @param mode Transport mode (passed by read_ function)
#'
#' @return A `data.frame` object with metadata subsetted by 'mode'
#' @keywords internal
#'
select_mode_input <- function(temp_meta=temp_meta, mode=NULL){

  checkmate::assert_string(mode, null.ok = FALSE)

  # Valid input
  if (mode %in% temp_meta$mode) { message(paste0("Using mode ", mode))
    temp_meta <- temp_meta[ temp_meta$mode %in% mode, ]
    return(temp_meta) }

  # invalid input
  else { stop(paste0("Error: This 'mode' is not available for this 'city' & 'year'. Please try another 'year' or one of the following modes: ",
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
#' @keywords internal
#'
select_metadata <- function(t=NULL, c=NULL, y=NULL, m=NULL){

# download metadata
  metadata <- as.data.frame(download_metadata())

  # check if download failed
  if (nrow(metadata)==0) { return(invisible(NULL)) }

  # Select data type
  temp_meta <- subset(metadata, type == t)

  # Select city input
  temp_meta <- select_city_input(temp_meta, city=c)

  # select year input
  if (t %in% c('access','land_use', 'population')) {
    temp_meta <- select_year_input(temp_meta, year=y)
  }

  # select mode input
  if (t=='access') {
    temp_meta <- select_mode_input(temp_meta, mode=m)
    }

  return(temp_meta)
}




#' Download data to a temporary directory.
#'
#' @description Save requested data (either an `sf` or a `data.frame`)
#'              to a temporary directory.
#'
#' @param url A string with the url address of aop dataset
#' @param progress_bar Logical. Defaults to (TRUE) display progress bar
#'
#' @return No visible output. The downloaded file (either an `sf` or a
#'         `data.frame`) is saved to a temporary directory.
#' @keywords internal
#'
download_data <- function(url, progress_bar = showProgress){

  if( !(progress_bar %in% c(T, F)) ){ stop("Value to argument 'showProgress' has to be either TRUE or FALSE") }

  # get backup links
  filenames <- basename(url)
  url2 <- paste0('https://github.com/ipeaGIT/aopdata/releases/download/v1.0.0/', filenames)

  ## one single file

  if (length(url)==1) {

    # location of temp_file
    temps <- paste0(tempdir(),"/", unlist(lapply(strsplit(url,"/"),tail,n=1L)))

    # check if file has not been downloaded already. If not, download it
    if (!file.exists(temps) | file.info(temps)$size == 0) {

      # test connection with server1
      try( silent = TRUE, check_con <- check_connection(url[1], silent = TRUE))
      if (is.null(check_con) | isFALSE(check_con)) {

        # if server1 fails, replace url and test connection with server2
        url <- url2
        try( silent = TRUE, check_con <- check_connection(url[1], silent = FALSE))
        if(is.null(check_con) | isFALSE(check_con)){ return(invisible(NULL)) }
        }
### 666 ao inves the checar url acima, tentar o download abaixo.
### 666 SE der errado, dai tentar no outro link

      ###
      # download data
      try( silent = TRUE,
           httr::GET(url=url,
                httr::timeout(10), ### 666 add time out to every httr::GET
                if(isTRUE(progress_bar)){httr::progress()},
                httr::write_disk(temps, overwrite = T))
           )
    }

    # load gpkg to memory
    temp_sf <- load_data(url, temps)
    return(temp_sf)
  }



  ## multiple files

  else if (length(url) > 1) {

    # input for progress bar
    total <- length(url)
    if(isTRUE(progress_bar)){
      pb <- utils::txtProgressBar(min = 0, max = total, style = 3)
    }

    # test connection with server1
    try( silent = TRUE, check_con <- check_connection(url[1], silent = TRUE))
    if (is.null(check_con) | isFALSE(check_con)) {

      # if server1 fails, replace url and test connection with server2
      url <- url2
      try( silent = TRUE, check_con <- check_connection(url[1], silent = FALSE))
      if(is.null(check_con) | isFALSE(check_con)){ return(invisible(NULL)) }
    }

    # download files
    lapply(X=url, function(x){

      # location of temp_file
      temps <- paste0(tempdir(),"/", unlist(lapply(strsplit(x,"/"),tail,n=1L)))

      # check if file has not been downloaded already. If not, download it
      if (!file.exists(temps) | file.info(temps)$size == 0) {
        i <- match(c(x),url)
        try( silent = TRUE,
             httr::GET(url=x, #httr::progress(),
                  httr::timeout(10),
                  httr::write_disk(temps, overwrite = T))
             )
        if(isTRUE(progress_bar)){ utils::setTxtProgressBar(pb, i) }
      }
    })

    # closing progress bar
    if(isTRUE(progress_bar)){close(pb)}

    # load gpkg
    temp_sf <- load_data(url)
    return(temp_sf)


  }

}



#' Load data from tempdir to global environment
#'
#' @description Reads data from tempdir to global environment.
#'
#' @param url A string with the url address of aop dataset
#' @param temps The address of a data file stored in tempdir. Defaults to NULL
#'
#' @return Returns either an `sf` or a `data.frame`, depending of the data set
#'         that was downloaded
#' @keywords internal
#'
load_data <- function(url, temps=NULL){

  # check if .csv or geopackage
  if( url[1] %like% '.csv' ){ fformat<- 'csv'}
  if( url[1] %like% '.gpkg' ){ fformat<- 'gpkg'}

  ### one single file
  if (length(url)==1) {

    # read file
    if( fformat=='csv' ){ temp <- data.table::fread(temps) }
    if( fformat=='gpkg' ){ temp <- sf::st_read(temps, quiet=T) }
    return(temp)
  }

  else if (length(url) > 1) {

    # read files and pile them up
    files <- unlist(lapply(strsplit(url,"/"), tail, n = 1L))
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
  temp_data <- load_data(url, temps)
  return(temp_data)
}



#' Spatial join of AOP data
#'
#' @description Merges land use or access data with H3 grid geometries
#'
#' @param aop_df A `data.frame` of aop data
#' @param aop_sf A spatial `sf` of aop data
#'
#' @return Returns a `data.frame sf` with access/land use data and grid geometries
#' @keywords internal
#'
aop_spatial_join <- function(aop_df, aop_sf){

  data.table::setDT(aop_df)
  data.table::setDT(aop_sf)
  data.table::setkeyv(aop_df, c('id_hex', 'abbrev_muni', 'name_muni', 'code_muni'))

  # merge
    # slower # aop <- data.table::merge.data.table(aop_df, aop_sf, by = 'id_hex')
    aop_df[aop_sf, on = 'id_hex', geometry := i.geom]

  # back to sf
  aop <- sf::st_sf(aop_df)
  aop <- subset(aop, id_hex != 'a')

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
#' @keywords internal
#'
aop_merge <- function(aop_landuse, aop_access){

  data.table::setDT(aop_landuse)
  data.table::setDT(aop_access)
  data.table::setkeyv(aop_landuse, c("id_hex", "abbrev_muni", "name_muni", "code_muni", "year"))
  data.table::setkeyv(aop_access,  c("id_hex", "abbrev_muni", "name_muni", "code_muni", "year"))

  # merge
  aop <- data.table::merge.data.table(aop_landuse, aop_access,
                                      by = c("id_hex", "abbrev_muni", "name_muni", "code_muni", "year"), all = TRUE) #'name_muni', 'code_muni',

  return(aop)
}




#' Check internet connection with Ipea server
#'
#' @description
#' Checks if there is an internet connection with Ipea server to download aop data.
#'
#' @param url A string with the url address of an aop dataset
#' @param silent Logical. Throw a message when silent is `FALSE` (default)
#'
#' @return Logical. `TRUE` if url is working, `FALSE` if not.
#'
#' @keywords internal
#'
check_connection <- function(url = 'https://www.ipea.gov.br/geobr/aopdata/metadata/metadata.csv', silent = FALSE){ # nocov start

  # url <- 'https://google.com/'               # ok
  # url <- 'https://www.google.com:81/'   # timeout
  # url <- 'https://httpbin.org/status/300' # error

  # check if user has internet connection
  if (!curl::has_internet()) {
    if(isFALSE(silent)){ message("No internet connection.") }

    return(FALSE)
  }

  # message
  msg <- "Problem connecting to data server. Please try again in a few minutes."

  # test server connection
  x <- try(silent = TRUE,
           httr::GET(url,
                     httr::timeout(10),
                     config = httr::config(ssl_verifypeer = FALSE)))
  # link offline
  if (methods::is(x)=="try-error") {
    if(isFALSE(silent)){ message( msg ) }
    return(FALSE)
  }

  # link working fine
  else if ( identical(httr::status_code(x), 200L)) {
    return(TRUE)
  }

  # link not working or timeout
  else if (! identical(httr::status_code(x), 200L)) {
    if(isFALSE(silent)){ message( msg ) }
    return(FALSE)

  } else if (httr::http_error(x) == TRUE) {
    if(isFALSE(silent)){ message( msg ) }
    return(FALSE)
  }

} # nocov end
