#' Support function to download metadata internally used in aopdata
#'
#' @keywords internal
#'
download_metadata <- function(){ # nocov start

  # create tempfile to save metadata
  tempf <- file.path(tempdir(), "metadata_aopdata.csv")

  # IF metadata has already been successfully downloaded
  if (file.exists(tempf) & file.info(tempf)$size != 0) {

  } else {

    # test server connection with github
    metadata_link <- 'https://github.com/ipeaGIT/aopdata/releases/download/v1.0.0/metadata.csv'
    try( silent = TRUE,
         check_con <- check_connection(metadata_link, silent = TRUE)
         )

    # if connection with github fails, try connection with ipea
    if (is.null(check_con) | isFALSE(check_con)) {
      metadata_link <- 'https://www.ipea.gov.br/geobr/aopdata/metadata/metadata.csv'
      try( silent = TRUE,
           check_con <- check_connection(metadata_link, silent = FALSE)
           )

      if (is.null(check_con) | isFALSE(check_con)) { return(invisible(NULL)) }
      }

    # download metadata to temp file
    try( silent = TRUE,
         curl::curl_download(
           url = metadata_link,
           destfile = tempf
           )
         )

    # if everything fails, return NULL
    if (!file.exists(tempf) | file.info(tempf)$size == 0) { return(invisible(NULL)) }
  }

 # read metadata
  metadata <- data.table::fread(tempf, stringsAsFactors=FALSE)

  # check if data was read Ok
  if (nrow(metadata)==0) {
    message("A file must have been corrupted during download. Please restart your R session and download the data again.")
    return(invisible(NULL))
  }

  return(metadata)

}  # nocov end
