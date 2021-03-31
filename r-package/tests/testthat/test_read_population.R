context("read_population")


### expected behavior ----------------
  test_that("read_population expected behavior", {

    # whole file
    expect_true(is(  read_population(city='nat', geometry = TRUE), 'sf'))
    expect_true(is(  read_population(city='nat', geometry = FALSE), 'data.frame'))

  })

### expected errors and messages ----------------

test_that("read_population errors and messages", {

  # Wrong city
  testthat::expect_error(read_population(city = 'abcdefg'))
  testthat::expect_error(read_population(city = 'abc'))

  # Wrong year
  testthat::expect_error(read_population(city = 'nat', year=1500))

  # Wrong geometry or showProgress
  testthat::expect_error(read_population(city = 'nat', year=2010, geometry = 'aaa'))
  testthat::expect_error(read_population(city = 'nat', year=2010, showProgress = 'aaa'))

})