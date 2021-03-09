
### expected behavior ----------------

test_that("read_grid expected behavior", {

  # whole file
  testthat::expect_output(object = read_grid(city='nat'))
  # testthat::expect_output(object = read_grid(city='nat', showProgress = FALSE))
  # testthat::expect_output(object = read_grid(city=c('all')))

})


### expected errors and messages ----------------

test_that("read_grid errors and messages", {

  # Wrong city
  testthat::expect_error(read_grid(city = 'abcdefg'))
  testthat::expect_error(read_grid(city = 'abc'))
  testthat::expect_error(read_grid(city = 1))
  testthat::expect_error(read_grid(city = NULL))

  # Wrong geometry or showProgress
  testthat::expect_error(read_access(read_grid = 'nat', showProgress = 'aaa'))

})
