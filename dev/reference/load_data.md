# Load data from tempdir to global environment

Reads data from tempdir to global environment.

## Usage

``` r
load_data(temps = NULL)
```

## Arguments

- temps:

  The address of a data file stored in tempdir. Defaults to NULL

## Value

Returns either an `sf` or a `data.frame`, depending of the data set that
was downloaded
