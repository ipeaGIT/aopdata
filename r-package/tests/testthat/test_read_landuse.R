context("read_landuse")

# skip tests because they take too much time
testthat::skip_on_cran()

### expected behavior ----------------
  test_that("read_landuse expected behavior", {

    # whole file
    expect_true(is(  read_landuse(city='nat', geometry = TRUE, showProgress = FALSE), 'sf'))
    expect_true(is(  read_landuse(city='nat', geometry = FALSE, showProgress = FALSE), 'data.frame'))
    expect_true(is(  read_landuse(city='nat', geometry = FALSE, showProgress = FALSE), 'data.frame'))
  })

### expected errors and messages ----------------

test_that("read_landuse errors and messages", {

  # Wrong city
  testthat::expect_error(read_landuse(city = 'abcdefg'))
  testthat::expect_error(read_landuse(city = 'abc'))

  # Wrong year
  testthat::expect_error(read_landuse(city = 'rec', year=1500))

  # Wrong geometry or showProgress
  testthat::expect_error(read_landuse(city = 'rec', year=2019, geometry = 'aaa'))
  testthat::expect_error(read_landuse(city = 'rec', year=2019, showProgress = 'aaa'))

})
