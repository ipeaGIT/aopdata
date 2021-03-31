context("read_access")


### expected behavior ----------------
  test_that("read_access expected behavior", {

    # whole file
    # testthat::expect_output(object = read_access(city='nat', year=2019))
    # testthat::expect_output(object = read_access(city='nat', geometry = TRUE))

    expect_true(is(  read_access(city='nat', geometry = TRUE), 'sf'))
    expect_true(is(  read_access(city='nat', geometry = FALSE), 'data.frame'))
    expect_true(is(  read_access(city='nat', geometry = FALSE, peak=FALSE), 'data.frame'))
    expect_true(is(  read_access(city='nat', geometry = FALSE, peak=FALSE, showProgress = FALSE), 'data.frame'))

  })

### expected errors and messages ----------------

test_that("read_access errors and messages", {

  # Wrong city
  testthat::expect_error(read_access(city = 'abcdefg'))
  testthat::expect_error(read_access(city = 'abc'))

  # Wrong year
  testthat::expect_error(read_access(city = 'nat', year=1500))

  # Wrong geometry, peak, showProgress
   testthat::expect_error(read_access(city = 'nat', year=2019, geometry = 'aaa'))
   testthat::expect_error(read_access(city = 'nat', year=2019, showProgress = 'aaa'))
   testthat::expect_error(read_access(city = 'nat', year=2019, peak = 'aaa'))

})
