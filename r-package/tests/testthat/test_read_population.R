context("read_population")

# skip tests because they take too much time
testthat::skip_on_cran()

### expected behavior ----------------
  test_that("read_population expected behavior", {

    # whole file
    expect_true(is(  read_population(city='nat', geometry = TRUE, showProgress = FALSE), 'sf'))
    expect_true(is(  read_population(city='nat', geometry = FALSE, showProgress = FALSE), 'data.frame'))

  })

### expected errors and messages ----------------

test_that("read_population errors and messages", {

  # Wrong city
  testthat::expect_error(read_population(city = 'abcdefg'))
  testthat::expect_error(read_population(city = 'abc'))

  # Wrong year
  testthat::expect_error(read_population(city = 'rec', year=1500))

  # Wrong geometry or showProgress
  testthat::expect_error(read_population(city = 'rec', year=2010, geometry = 'aaa'))
  testthat::expect_error(read_population(city = 'rec', year=2010, showProgress = 'aaa'))

})
