# Select metadata

Subsets the metadata table by data 'type', 'city', 'year' and 'mode'

## Usage

``` r
select_metadata(t = NULL, c = NULL, y = NULL, m = NULL)
```

## Arguments

- t:

  Type of data: 'access' or 'grid' (passed from `read_` function)

- c:

  City (passed from `read_` function)

- y:

  Year of the dataset (passed from `read_` function)

- m:

  Transport mode (passed from `read_` function)

## Value

A `data.frame` object with metadata subsetted by data type, 'city',
'year' and 'mode'
