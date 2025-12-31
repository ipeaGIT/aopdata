# Select year input

Subsets the metadata table by 'year'.

## Usage

``` r
select_year_input(temp_meta = temp_meta, year = NULL)
```

## Arguments

- temp_meta:

  A data.frame with the url addresses of aop datasets

- year:

  Year of the dataset (passed from read\_ function)

## Value

A `data.frame` object with metadata subsetted by 'year'
