# Select mode input

Subsets the metadata table by 'mode'.

## Usage

``` r
select_mode_input(temp_meta = temp_meta, mode = NULL)
```

## Arguments

- temp_meta:

  A data.frame with the url addresses of aop datasets

- mode:

  Transport mode (passed by read\_ function)

## Value

A `data.frame` object with metadata subsetted by 'mode'
