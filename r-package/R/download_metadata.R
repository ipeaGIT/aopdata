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

  } else {

    # test server connection
    metadata_link <- 'https://www.ipea.gov.br/geobr/aopdata/metadata/metadata.csv'
    check_connection(metadata_link)

    # download metadata to temp file
    httr::GET(url= metadata_link, httr::write_disk(tempf, overwrite = T))
  }

 # read metadata
  metadata <- data.table::fread(tempf, stringsAsFactors=F)
  return(metadata)
  }
