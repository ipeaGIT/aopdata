#' Support function to download metadata internally used in 'aopdata'
#'
#' @return A `data.frame` object with metadata and url of data sets
#'
#' @export
#' @family general support functions
#' @examples \donttest{
#' df <- download_metadata()
#'}
download_metadata <- function(){

  # create tempfile to save metadata
  tempf <- file.path(tempdir(), "metadata_aopdata.csv")

  # check if metadata has already been downloaded
  if (file.exists(tempf)) {
    metadata <- data.table::fread(tempf, stringsAsFactors=F)

  } else {

# #supress warnings
# oldw <- getOption("warn")
# options(warn = -1)

    # test server connection
    metadata_link <- 'http://www.ipea.gov.br/geobr/aopdata/metadata/metadata.csv'
    con <- url(metadata_link)
    t <- suppressWarnings({ try( open.connection(con, open="rt", timeout=2), silent=T)[1] })
    if("try-error" %in% class(t)){stop('Internet connection problem. If this is not a connection problem in your network, please try aop again in a few minutes.')}
    suppressWarnings({ try(close.connection(con), silent=T) })

# # return with warnings
# options(warn = oldw)

    # download it and save to metadata
    httr::GET(url= metadata_link, httr::write_disk(tempf, overwrite = T))
    metadata <- data.table::fread(tempf, stringsAsFactors=F)
    }


  return(metadata)
  }
