context("read_grid")

### expected behavior ----------------

test_that("read_grid expected behavior", {

  # whole file
  expect_true(is(  read_grid(city='nat'), 'sf'))
  expect_true(is(  read_grid(city='Natal'), 'sf'))

})


### expected errors and messages ----------------

test_that("read_grid errors and messages", {

  # Wrong city
  testthat::expect_error(read_grid(city = 'abcdefg'))
  testthat::expect_error(read_grid(city = 'abc'))
  testthat::expect_error(read_grid(city = 'a'))
  testthat::expect_error(read_grid(city = 1))
  testthat::expect_error(read_grid(city = NULL))
  testthat::expect_error(read_grid())

  # Wrong geometry or showProgress
  testthat::expect_error( read_grid(city = 'nat', showProgress = 'aaa'))
  testthat::expect_error( read_grid(city = 'nat', showProgress = 333))
  testthat::expect_error( read_grid(city = 'nat', showProgress = NULL))

})
