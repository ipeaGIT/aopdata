context("utils")

# skip tests because they take too much time
testthat::skip_on_cran()




# ### download metadata ----------------
#
# testthat::test_that("gracefully fail if could not download metadata", {
#
#   # meta data
#   testthat::local_mocked_bindings(
#     check_connection = function(...) { FALSE }
#   )
#   testthat::expect_null( download_metadata() )
# })
#


### check connection ----------------
# url <- 'https://www.google.com:81/'   # timeout
# url <- 'https://httpbin.org/status/300' # error

testthat::test_that("check connection", {

  # timeout
  testthat::expect_false( check_connection(url = 'https://www.google.com:81/') )

  # connection error
  testthat::expect_false( check_connection(url = 'https://httpbin.org/status/300') )

  # check_downloaded_obj
  testthat::expect_null( check_downloaded_obj(NULL) )
  testthat::expect_message( check_downloaded_obj(NULL) )

})
