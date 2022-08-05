#' aopdata data dictionary
#'
#' @description
#' Opens aopdata data dictionary on a web browser. This function requires
#' internet connection.
#'
#' @param lang Character. Language of data dictionary. It can be either `"en"`
#'        for English (default) or `"pt"` for Portuguese.
#'
#' @return  Opens aopdata data dictionary on a web browser
#'
#' @export
#' @family support functions
#' @examples \dontrun{ if (interactive()) {
#'
#' # Data dictionary in English
#' aopdata_dictionary(lang='en')
#'
#' #' # Data dictionary in Portuguese
#' aopdata_dictionary(lang='pt')
#'
#'}}
aopdata_dictionary <- function(lang='en'){

  # checks
  checkmate::assert_string(lang, pattern = 'en|pt')

  if(lang=='en'){ utils::browseURL("https://ipeagit.github.io/aopdata/articles/data_dic_en.html") }
  if(lang=='pt'){ utils::browseURL("https://ipeagit.github.io/aopdata/articles/data_dic_pt.html") }

  return(invisible(NULL))
}
