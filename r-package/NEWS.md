# log history of aopdata package development



-------------------------------------------------------

# aopdata v0.2.3

**Minor changes**
* Download functions should now fail gracefully with an informative message when there are internet connection problems.
* Remove `crul` from package dependencies.
* skip examples on CRAN. Examples now only run on interactive R sessions.



-------------------------------------------------------

# aopdata v0.2.2

**Minor changes**
* Adds `crul` as a package dependency. Now aoptadata fails gracefully when there is internet connection problems. Closes #32.
* `showProgress` now sets to `FALSE` in all tests, examples and vignettes. Closes #32.
* skip tests on CRAN. Tests are run only locally




-------------------------------------------------------

# aopdata v0.2.1

**Minor changes**
* Allow for user to download data few selected cities. Closes #29
* Fix  progress bar even when showProgress = F. Closes #30
* Fix  encoding issues using `base::iconv(city, to="ASCII//TRANSLIT")`. Closes #31


-------------------------------------------------------

# aopdata v0.2.0

**Major changes**
* New function read_population. Closes #21
* New parameter `peak` added to `read_access()` function. Closes #17
* New internal support function `is_online()` to alert for possible internet connection problem. Closes #26
* Chache downloaded data in tempdir. Closes #28

**Minor changes**
* Downloads two or more cities at the same time. Closes #3.


-------------------------------------------------------

# aopdata v0.1.0

* Submitted to CRAN
