
<!-- README.md is generated from README.Rmd. Please edit that file -->

# sdf

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/sdf)](https://CRAN.R-project.org/package=sdf)
<!-- badges: end -->

The goal of `{sdf}` is to provide an extensible spatial data frame. It
is inspired by Rust traits where if you implement the correct generics,
you get a ton of sweet benefits.

By implementing the required generics your geometry type can become an
`sdf` (spatial data frame).

## Installation

You can install the development version of sdf like so:

``` r
remotes::install_github("josiahparry/sdf")
```

## Example

``` r
library(sdf)

data(guerry, package = "sfdep")

# using sf
sdf_sf <- as_sdf(guerry)

sdf_sf
#> Geometry Type: sfc_MULTIPOLYGON
#> Bounding box: xmin: 47680 ymin: 1703258 xmax: 1031401 ymax: 2677441
#> # A tibble: 85 × 27
#>    code_dept count ave_id…¹  dept region depar…² crime…³ crime…⁴ liter…⁵ donat…⁶
#>    <fct>     <dbl>    <dbl> <int> <fct>  <fct>     <int>   <int>   <int>   <int>
#>  1 01            1       49     1 E      Ain       28870   15890      37    5098
#>  2 02            1      812     2 N      Aisne     26226    5521      51    8901
#>  3 03            1     1418     3 C      Allier    26747    7925      13   10973
#>  4 04            1     1603     4 E      Basses…   12935    7289      46    2733
#>  5 05            1     1802     5 E      Hautes…   17488    8174      69    6962
#>  6 07            1     2249     7 S      Ardeche    9474   10263      27    3188
#>  7 08            1    35395     8 N      Ardenn…   35203    8847      67    6400
#>  8 09            1     2526     9 S      Ariege     6173    9597      18    3542
#>  9 10            1    34410    10 E      Aube      19602    4086      59    3608
#> 10 11            1     2807    11 S      Aude      15647   10431      34    2582
#> # … with 75 more rows, 17 more variables: infants <int>, suicides <int>,
#> #   main_city <ord>, wealth <int>, commerce <int>, clergy <int>,
#> #   crime_parents <int>, infanticide <int>, donation_clergy <int>,
#> #   lottery <int>, desertion <int>, instruction <int>, prostitutes <int>,
#> #   distance <dbl>, area <int>, pop1831 <dbl>, geometry <MULTIPOLYGON>, and
#> #   abbreviated variable names ¹​ave_id_geo, ²​department, ³​crime_pers,
#> #   ⁴​crime_prop, ⁵​literacy, ⁶​donations

# using rust
sdf_rs <- as_sdf(
  dplyr::mutate(guerry, geometry = rsgeo::as_rsgeom(geometry))
)

sdf_rs
#> Geometry Type: rs_MULTIPOLYGON
#> Bounding box: x_min: 47680 x_max: 1031401 y_min: 1703258 y_max: 2677441
#> # A tibble: 85 × 27
#>    code_dept count ave_id…¹  dept region depar…² crime…³ crime…⁴ liter…⁵ donat…⁶
#>    <fct>     <dbl>    <dbl> <int> <fct>  <fct>     <int>   <int>   <int>   <int>
#>  1 01            1       49     1 E      Ain       28870   15890      37    5098
#>  2 02            1      812     2 N      Aisne     26226    5521      51    8901
#>  3 03            1     1418     3 C      Allier    26747    7925      13   10973
#>  4 04            1     1603     4 E      Basses…   12935    7289      46    2733
#>  5 05            1     1802     5 E      Hautes…   17488    8174      69    6962
#>  6 07            1     2249     7 S      Ardeche    9474   10263      27    3188
#>  7 08            1    35395     8 N      Ardenn…   35203    8847      67    6400
#>  8 09            1     2526     9 S      Ariege     6173    9597      18    3542
#>  9 10            1    34410    10 E      Aube      19602    4086      59    3608
#> 10 11            1     2807    11 S      Aude      15647   10431      34    2582
#> # … with 75 more rows, 17 more variables: infants <int>, suicides <int>,
#> #   main_city <ord>, wealth <int>, commerce <int>, clergy <int>,
#> #   crime_parents <int>, infanticide <int>, donation_clergy <int>,
#> #   lottery <int>, desertion <int>, instruction <int>, prostitutes <int>,
#> #   distance <dbl>, area <int>, pop1831 <dbl>, geometry <MPOLY>, and
#> #   abbreviated variable names ¹​ave_id_geo, ²​department, ³​crime_pers,
#> #   ⁴​crime_prop, ⁵​literacy, ⁶​donations
```

``` r
library(dplyr, warn.conflicts = FALSE)

sdf_sf |> 
  group_by(region) |> 
  summarise(total_crime = sum(crime_pers))
#> Geometry Type: sfc_MULTIPOLYGON
#> Bounding box: xmin: 47680 ymin: 1703258 xmax: 1031401 ymax: 2677441
#> # A tibble: 5 × 3
#>   region total_crime                                                    geometry
#>   <fct>        <int>                                              <MULTIPOLYGON>
#> 1 C           385123 (((710830 2137350, 711746 2136617, 712430 2135212, 712070 …
#> 2 E           342028 (((801150 2092615, 800669 2093190, 800688 2095430, 800780 …
#> 3 N           384061 (((729326 2521619, 729320 2521230, 729280 2518544, 728751 …
#> 4 S           203226 (((747008 1925789, 746630 1925762, 745723 1925138, 744216 …
#> 5 W           382242 (((456425 2120055, 456229 2120382, 455943 2121064, 456070 …

sdf_rs |> 
  group_by(region) |> 
  summarise(total_crime = sum(crime_pers))
#> Geometry Type: rs_MULTIPOLYGON
#> Bounding box: x_min: 47680 x_max: 1031401 y_min: 1703258 y_max: 2677441
#> # A tibble: 5 × 3
#>   region total_crime geometry      
#>   <fct>        <int> <MPOLY>       
#> 1 C           385123 <MultiPolygon>
#> 2 E           342028 <MultiPolygon>
#> 3 N           384061 <MultiPolygon>
#> 4 S           203226 <MultiPolygon>
#> 5 W           382242 <MultiPolygon>
```

## Required method implementations

As of now presently only 2 generics are required to get basic
functionality

- `bounding_box()`
- `combine_geometry()`

…

additional generics will be added here
