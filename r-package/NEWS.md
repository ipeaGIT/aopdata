# aopdata v1.0.0 (dev version)

**Major changes**

- New function `aopdata_dictionary()` to aopdata data dictionary on a web browser.
- All data sets are now simultaneously stored on github and on Ipea's server. The package now downloads the data from github. In case the github link is off line for some reason, then the package tries to download the data from Ipea's server. For users, the effect of this change is that the package is much more stable and less vulnerable to instabilities in Ipea's data server connection.
- New data sets:
  - Year coverage
    - Access and Land use data sets now cover years **2017, 2018 and 2019**

  - New cities
    - Data for Goiania now covers the entire **metro area of Goiania** in 2019.

  - New modes
    - Access data now bring accessibility estimates by **car**

  - New activities
    - Land use and access data now bring data for **centers for social assistance (CRAS)**
    - Population data sets with minor spatial corrections to smooth spatial distributions


**Minor changes**

- `read_` functions now have no default value for the `city` parameter. [Closes #38](https://github.com/ipeaGIT/aopdata/issues/38).
- Fixed `ERROR` message when there is no data for a particular transport mode for an specific city & year.




# aopdata v0.2.3

## Minor changes
- Download functions should now fail gracefully with an informative message when there are internet connection problems.
- Remove `crul` from package dependencies.
- skip examples on CRAN. Examples now only run on interactive R sessions.
- update links from http to https



# aopdata v0.2.2

## Minor changes
- Adds `crul` as a package dependency. Now aoptadata fails gracefully when there is internet connection problems. Closes #32.
- `showProgress` now sets to `FALSE` in all tests, examples and vignettes. Closes #32.
- skip tests on CRAN. Tests are run only locally




# aopdata v0.2.1

## Minor changes
- Allow for user to download data few selected cities. Closes #29
- Fix  progress bar even when showProgress = F. Closes #30
- Fix  encoding issues using `base::iconv(city, to="ASCII//TRANSLIT")`. Closes #31




# aopdata v0.2.0

## Major changes
- New function read_population. Closes #21
- New parameter `peak` added to `read_access()` function. Closes #17
- New internal support function `is_online()` to alert for possible internet connection problem. Closes #26
- Chache downloaded data in tempdir. Closes #28

## Minor changes
- Downloads two or more cities at the same time. Closes #3.



# aopdata v0.1.0

- First version on CRAN
