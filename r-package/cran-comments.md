## R CMD check results ---------------------------------------------------------- aopdata 1.0.0 ----
Duration: 4m 33.3s

0 errors v | 0 warnings v | 0 notes v

* This is a submission to get the package back on CRAN.
* Words in DESCRIPTION are not misspelled, and are now netween 'quotes'
* Replaced `class(x)=="try-error"` with `methods::is(x)=="try-error"`

The aopdata package was suspended on CRAN on February 2022 because it continuously failed CRAN's policy to "fail gracefully" when there are any internet connection problems.

We have scrutinized the package, which has now gone through strcutural changes to address this issue. Here are the main changes:
1. New internal function `check_connection()` and tests that cover cases when users have no internet connection, whem url links are offline, time out or work normally.
2. All functions that require internet connection now use `check_connection()` and return informative messages when url links are offline or timeout.
3. The data used in the pacakge is now simultaneously stored in two indepentend servers, where one of them is used as a backup link. In other words, the aopdata will download the data from server 1. If, some some reason, the download fails because of internet connection problems, then aopdata tries to download the data from server 2. If this second attempt fails, then package returns `invisible(NULL)` with an informative message.

We believe these changes and the redundancy in data storage have made the aopdata package substantially more robust and in line with CRAN's policies.


