# Spatial join of AOP data

Merges land use or access data with H3 grid geometries

## Usage

``` r
aop_spatial_join(aop_df, aop_sf)
```

## Arguments

- aop_df:

  A `data.frame` of aop data

- aop_sf:

  A spatial `sf` of aop data

## Value

Returns a `data.frame sf` with access/land use data and grid geometries
