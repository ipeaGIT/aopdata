# Download data to a temporary directory.

Save requested data (either an `sf` or a `data.frame`) to a temporary
directory.

## Usage

``` r
download_data(url, progress_bar = showProgress)
```

## Arguments

- url:

  A string with the url address of aop dataset

- progress_bar:

  Logical. Defaults to (TRUE) display progress bar

## Value

No visible output. The downloaded file (either an `sf` or a
`data.frame`) is saved to a temporary directory.
