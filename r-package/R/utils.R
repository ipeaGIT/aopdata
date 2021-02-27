############# Support functions for aop
# nocov start


#' Select city input
#'
#' @param temp_meta A dataframe with the file_url addresses of aop datasets
#' @param city city input (passed from read_ function)
#' @export
#' @family support functions
#'
select_city_input <- function(temp_meta=temp_meta, city=NULL){

  # NULL
  if (is.null(city)){  stop(paste0("Error: Invalid Value to argument 'city'. It must be one of the following: ",
                                paste(unique(temp_meta$name_muni),collapse = " | "))) }

  # 3 letter-abbreviation
  if (nchar(city)==3) {

      # valid input 'all'
      if (city %in% 'all'){ return(temp_meta) }

      # valid input
      if (city %in% temp_meta$city){ temp_meta <- temp_meta[ temp_meta$city == city, ]
                                  return(temp_meta) }


      # invalid input
      else { stop(paste0("Error: Invalid Value to argument 'city'. It must be one of the following: ",
                         paste(unique(temp_meta$city), collapse = " | "))) }
    }


  # full name
  if (nchar(city)>3) {

    city <- tolower(city)
    city <- rm_accent(city)

    # valid input
    if (city %in% temp_meta$name_muni){ temp_meta <- temp_meta[ temp_meta$name_muni == city, ]
                                        return(temp_meta)
                                      }

    # invalid input
    else { stop(paste0("Error: Invalid Value to argument 'city'. It must be one of the following: ",
                       paste(unique(temp_meta$name_muni), collapse = " | "))) }
  }
}




#' Select year input
#'
#' @param temp_meta A dataframe with the file_url addresses of aop datasets
#' @param year Year of the dataset (passed from read_ function)
#' @export
#' @family support functions
#'
select_year_input <- function(temp_meta=temp_meta, year=NULL){

  # NULL
  if (is.null(year)){  stop(paste0("Error: Invalid Value to argument 'year'. It must be one of the following: ",
                                   paste(unique(temp_meta$year),collapse = " "))) }

  # invalid input
  else if (year %in% temp_meta$year){ message(paste0("Using year ", year))
                                  temp_meta <- temp_meta[ temp_meta$year == year, ]
                                  return(temp_meta) }

  # invalid input
  else { stop(paste0("Error: Invalid Value to argument 'year'. It must be one of the following: ",
                         paste(unique(temp_meta$year), collapse = " ")))
    }
}




#' Select mode input
#'
#' @param temp_meta A dataframe with the file_url addresses of aop datasets
#' @param mode Transport mode (passed by read_ function)
#' @export
#' @family support functions
#'
select_mode_input <- function(temp_meta=temp_meta, mode=NULL){

  # NULL
  if (is.null(mode)){  stop(paste0("Error: Invalid Value to argument 'mode'. It must be one of the following: ",
                                paste(unique(temp_meta$mode),collapse = " "))) }

  # invalid input
  else if (mode %in% temp_meta$mode){ message(paste0("Using mode ", mode))
    temp_meta <- temp_meta[ temp_meta$mode == mode, ]
    return(temp_meta) }

  # invalid input
  else { stop(paste0("Error: Invalid Value to argument 'mode'. It must be one of the following: ",
                     paste(unique(temp_meta$mode), collapse = " ")))
  }
}





#' Select metadata
#'
#' @param t Type of data: 'access' or 'grid' (passed from `read_` function)
#' @param c City (passed from `read_` function)
#' @param m Transport mode (passed from `read_` function)
#' @param y Year of the dataset (passed from `read_` function)
#'
#' @export
#' @family support functions
#' @examples \donttest{
#'
#' df <- download_metadata()
#'
#' }
#'
select_metadata <- function(t=NULL, c=NULL, y=NULL, m=NULL){

# download metadata
  metadata <- as.data.frame(download_metadata())

  # Select data type
  temp_meta <- subset(metadata, type == t)

  # Select city input
  temp_meta <- select_city_input(temp_meta, city=c)

  if(t=='access'){

    # Select mode and year
    temp_meta <- select_year_input(temp_meta, year=y)
    temp_meta <- select_mode_input(temp_meta, mode=m)
    }

  return(temp_meta)
}




#' Download geopackage to tempdir
#'
#'
#' @param file_url A string with the file_url address of a aop dataset
#' @param progress_bar Logical. Defaults to (TRUE) display progress bar
#' @export
#' @family support functions
#'
download_gpkg <- function(file_url, progress_bar = showProgress){

  if( !(progress_bar %in% c(T, F)) ){ stop("Value to argument 'showProgress' has to be either TRUE or FALSE") }

## one single file

  if(length(file_url)==1 & progress_bar == TRUE){

    # download file
    temps <- paste0(tempdir(),"/", unlist(lapply(strsplit(file_url,"/"),tail,n=1L)))
    httr::GET(url=file_url, httr::progress(), httr::write_disk(temps, overwrite = T))

    # load gpkg
    temp_sf <- load_gpkg(file_url, temps)
    return(temp_sf)


    }

  else if(length(file_url)==1 & progress_bar == FALSE){

    # download file
    temps <- paste0(tempdir(),"/", unlist(lapply(strsplit(file_url,"/"),tail,n=1L)))
    httr::GET(url=file_url, httr::write_disk(temps, overwrite = T))

    # load gpkg
    temp_sf <- load_gpkg(file_url, temps)
    return(temp_sf)
  }



## multiple files

  else if(length(file_url) > 1 & progress_bar == TRUE) {

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

    # load gpkg
    temp_sf <- load_gpkg(file_url)
    return(temp_sf)


    }

  else if(length(file_url) > 1 & progress_bar == FALSE) {

    # download files
    lapply(X=file_url, function(x){
      i <- match(c(x),file_url)
      httr::GET(url=x, #httr::progress(),
                httr::write_disk(paste0(tempdir(),"/", unlist(lapply(strsplit(x,"/"),tail,n=1L))), overwrite = T))})


    # load gpkg
    temp_sf <- load_gpkg(file_url)
    return(temp_sf)

    }
}




#' Load geopackage from tempdir to global environment
#'
#' @param file_url A string with the file_url address of a aop dataset
#' @param temps The address of a gpkg file stored in tempdir. Defaults to NULL
#' @export
#' @family support functions
#'
load_gpkg <- function(file_url, temps=NULL){

  ### one single file

  if(length(file_url)==1){

    # read sf
    temp_sf <- sf::st_read(temps, quiet=T)
    return(temp_sf)
  }

  else if(length(file_url) > 1){

    # read files and pile them up
    files <- unlist(lapply(strsplit(file_url,"/"), tail, n = 1L))
    files <- paste0(tempdir(),"/",files)
    files <- lapply(X=files, FUN= sf::st_read, quiet=T)
    temp_sf <- sf::st_as_sf(data.table::rbindlist(files, fill = TRUE)) # do.call('rbind', files)
    return(temp_sf)
  }

  # load gpkg to memory
  temp_sf <- load_gpkg(file_url, temps)
  return(temp_sf)
}




#' Remove accents from string
#'
#' @param str A string
#' @param pattern A pattern
#' @export
#' @family support functions
#'
rm_accent <- function(str, pattern="all") {
  if(!is.character(str))
    str <- as.character(str)
  pattern <- unique(pattern)
  if(any(pattern=="Ç"))
    pattern[pattern=="Ç"] <- "ç"
  symbols <- c(
    acute = "áéíóúÁÉÍÓÚýÝ",
    grave = "àèìòùÀÈÌÒÙ",
    circunflex = "âêîôûÂÊÎÔÛ",
    tilde = "ãõÃÕñÑ",
    umlaut = "äëïöüÄËÏÖÜÿ",
    cedil = "çÇ"
  )
  nudeSymbols <- c(
    acute = "aeiouAEIOUyY",
    grave = "aeiouAEIOU",
    circunflex = "aeiouAEIOU",
    tilde = "aoAOnN",
    umlaut = "aeiouAEIOUy",
    cedil = "cC"
  )
  accentTypes <- c("´","`","^","~","¨","ç")
  if(any(c("all","al","a","todos","t","to","tod","todo")%in%pattern)) # opcao retirar todos
    return(chartr(paste(symbols, collapse=""), paste(nudeSymbols, collapse=""), str))
  for(i in which(accentTypes%in%pattern))
    str <- chartr(symbols[i],nudeSymbols[i], str)
  return(str)
}


#' Spatial join of AOP data
#'
#' @param aop_df A `data.frame` of aop data
#' @param aop_sf A spatial `sf` of aop data
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


# nocov end
