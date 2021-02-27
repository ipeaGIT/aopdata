############# Support functions for aop
# nocov start


#' Select city input
#'
#' @param temp_meta A dataframe with the file_url addresses of geobr datasets
#' @param city city input (passed from read_ function)
#' @export
#' @family support functions
#'
select_city_input <- function(temp_meta, c=city){

  # NULL
  if (is.null(c)){  stop(paste0("Error: Invalid Value to argument 'city'. It must be one of the following: ",
                                paste(unique(temp_meta$name_muni),collapse = " | "))) }

  # 3 letter-abbreviation
  if (nchar(c)==3){

      # valid input 'all'
      if (c %in% 'all'){ return(temp_meta) }

      # valid input
      if (c %in% temp_meta$city){ temp_meta <- subset(temp_meta, city == c)
                                  return(temp_meta) }

      # invalid input
      else { stop(paste0("Error: Invalid Value to argument 'city'. It must be one of the following: ",
                         paste(unique(temp_meta$city), collapse = " | "))) }
    }


  # full name
  if (nchar(c)>3){

    c <- tolower(c)
    c <- rm_accent(c)

    # valid input
    if (c %in% temp_meta$name_muni){ temp_meta <- subset(temp_meta, name_muni == c)
    return(temp_meta) }

    # invalid input
    else { stop(paste0("Error: Invalid Value to argument 'city'. It must be one of the following: ",
                       paste(unique(temp_meta$name_muni), collapse = " | "))) }
  }
}




#' Select year input
#'
#' @param temp_meta A dataframe with the file_url addresses of geobr datasets
#' @param year Year of the dataset (passed from read_ function)
#' @export
#' @family support functions
#'
select_year_input <- function(temp_meta, year=y){

  # NULL
  if (is.null(year)){  stop(paste0("Error: Invalid Value to argument 'year'. It must be one of the following: ",
                                   paste(unique(temp_meta$year),collapse = " "))) }

  # invalid input
  else if (year %in% temp_meta$year){ message(paste0("Using year ", year))
                                  temp_meta <- subset(temp_meta, year %in% year)
                                  return(temp_meta) }

  # invalid input
  else { stop(paste0("Error: Invalid Value to argument 'year'. It must be one of the following: ",
                         paste(unique(temp_meta$year), collapse = " ")))
    }
}




#' Select mode input
#'
#' @param temp_meta A dataframe with the file_url addresses of aop datasets
#' @param m Transport mode (passed by read_ function)
#' @export
#' @family support functions
#'
select_mode_input <- function(temp_meta, m=mode){

  # NULL
  if (is.null(m)){  stop(paste0("Error: Invalid Value to argument 'mode'. It must be one of the following: ",
                                paste(unique(temp_meta$mode),collapse = " "))) }

  # invalid input
  else if (m %in% temp_meta$mode){ message(paste0("Using mode ", m))
    temp_meta <- subset(temp_meta, mode == m)
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
#' library(geobr)
#'
#' df <- download_metadata()
#'
#' }
#'
select_metadata <- function(t=NULL, c=NULL, m=NULL, y=NULL){

# download metadata
  metadata <- download_metadata()

  # Select data type
  temp_meta <- subset(metadata, type == t)

  # Select city input
  temp_meta <- select_city_input(temp_meta, c=city)

  if(t=='access'){

    # Select mode and year
    temp_meta <- select_year_input(temp_meta, year=y)
    temp_meta <- select_mode_input(temp_meta, m=m)
    }

  return(temp_meta)
}




#' Download geopackage to tempdir
#'
#'
#' @param file_url A string with the file_url address of a geobr dataset
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
#' @param file_url A string with the file_url address of a geobr dataset
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

# nocov end
