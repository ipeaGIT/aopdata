context("read_access")

# skip tests because they take too much time
testthat::skip_on_cran()

### expected behavior ----------------
  test_that("read_access expected behavior", {

    # whole file
    # testthat::expect_output(object = read_access(city='nat', year=2019))
    # testthat::expect_output(object = read_access(city='nat', geometry = TRUE))

    expect_true(is(  read_access(city='nat', geometry = TRUE, showProgress = FALSE), 'sf'))
    expect_true(is(  read_access(city='nat', geometry = FALSE, showProgress = FALSE), 'data.frame'))
    expect_true(is(  read_access(city='nat', geometry = FALSE, peak=FALSE, showProgress = FALSE), 'data.frame'))
    expect_true(is(  read_access(city='nat', geometry = FALSE, peak=FALSE, showProgress = FALSE), 'data.frame'))
  })


test_that("read_access expected behavior multiple cities", {

  # whole file
  # testthat::expect_output(object = read_access(city='nat', year=2019))
  # testthat::expect_output(object = read_access(city='nat', geometry = TRUE))

  test_walk <- read_access(city=c('nat', 'for'), mode= 'walk', geometry = FALSE, showProgress = FALSE)
  test_walk <- subset(test_walk, !is.na(mode))
  expect_true(is(  test_walk, 'data.frame'))
  expect_equal(  length(unique(test_walk$abbrev_muni)) , 2)
  expect_equal(  unique(test_walk$mode) , 'walk')


  test_pt <- read_access(city=c('rec', 'for'), mode= 'public_transport', geometry = FALSE, showProgress = FALSE)
  test_pt <- subset(test_pt, !is.na(mode))
  expect_true(is(  test_pt, 'data.frame'))
  expect_equal(  length(unique(test_pt$abbrev_muni)) , 2)
  expect_equal(  unique(test_pt$mode) , 'public_transport')


})



### expected errors and messages ----------------

test_that("read_access errors and messages", {

  # Wrong city
  testthat::expect_error(read_access(city = 'abcdefg', showProgress = FALSE))
  testthat::expect_error(read_access(city = 'abc', showProgress = FALSE))
  testthat::expect_error(read_access( showProgress = FALSE))

  # Wrong year
  testthat::expect_error(read_access(city = 'rec', year=1500, showProgress = FALSE))

   # Wrong mode
   testthat::expect_error( read_access(city=c('nat', 'poa'), mode= 'public_transport', geometry = FALSE, showProgress = FALSE) )
   testthat::expect_error( read_access(city='nat', mode= 'public_transport', geometry = FALSE, showProgress = FALSE) )

    # Wrong geometry, peak, showProgress
   testthat::expect_error(read_access(city = 'rec', year=2019, geometry = 'aaa'))
   testthat::expect_error(read_access(city = 'rec', year=2019, showProgress = 'aaa'))
   testthat::expect_error(read_access(city = 'rec', year=2019, peak = 'aaa'))

})
