

### expected behavior ----------------
  test_that("read_population expected behavior", {

    # whole file
    testthat::expect_output(object = read_population(city='nat', geometry = T))
    testthat::expect_output(object = read_population(city='nat', geometry = F))
  })

### expected errors and messages ----------------

test_that("read_population errors and messages", {

  # Wrong city
  testthat::expect_error(read_population(city = 'abcdefg'))
  testthat::expect_error(read_population(city = 'abc'))

  # Wrong year
  testthat::expect_error(read_population(city = 'nat', year=1500))

  # Wrong geometry or showProgress
  testthat::expect_error(read_population(city = 'nat', year=2019, geometry = 'aaa'))
  testthat::expect_error(read_population(city = 'nat', year=2019, showProgress = 'aaa'))

})
