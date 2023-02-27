
<!-- README.md is generated from README.Rmd. Please edit that file -->

# sdf

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!--[![CRAN status](https://www.r-pkg.org/badges/version/sdf)](https://CRAN.R-project.org/package=sdf)-->
<!-- badges: end -->

The goal of `{sdf}` is to provide an extensible spatial data frame. sdf
acts as a common interface to a variety of different geometry types. sdf
is inspired in part by dplyr where the dplyr syntax acts as an interface
that can be utilized by a number of different of data sources without
changing the syntax—e.g. dbplyr, sparklyr, dtplyr, among others.

It is inspired by Rust traits where if you implement the correct
generics, you get a ton of sweet benefits. By implementing the required
generics your geometry type can become an `sdf` (spatial data frame).

If you don’t know what is meant by “generic” [start
here](https://adv-r.hadley.nz/s3.html).

## Installation

You can install the development version of sdf like so:

``` r
remotes::install_github("josiahparry/sdf")
```

## Example

``` r
library(sdf)

# pull some spatial data
data(guerry, package = "sfdep")
g <- dplyr::select(guerry, code_dept, crime_pers, region)

# using sf, cast to a spatial data frame
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
  # convert geometry to rust geometry
  dplyr::mutate(guerry, geometry = rsgeo::as_rsgeom(geometry))
)

sdf_rs
#> Geometry Type: rs_MULTIPOLYGON
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
#> Bounding box: xmin: 47680 ymin: 1703258 xmax: 1031401 ymax: 2677441
#> # A tibble: 5 × 3
#>   region total_crime geometry      
#>   <fct>        <int> <MULTIPOLYGON>
#> 1 C           385123 <MultiPolygon>
#> 2 E           342028 <MultiPolygon>
#> 3 N           384061 <MultiPolygon>
#> 4 S           203226 <MultiPolygon>
#> 5 W           382242 <MultiPolygon>
```

## Required method implementations

The following generics must have an implementation for your geometry
class. The geometry class must be an S3 object / compatible with a data
frame.

- `c`
- `is_geometry()`
- `bounding_box()`
- `combine_geometry()`

Implementing these generics provides access to dplyr functionality only.

## Spatial joins and filters

The functions `sdf_join()` and `sdf_filter()` have an argument
`predicate` which takes a predicate function—by default
`sdf_intersects()`. For two spatial data frames `x` and `y` the
predicate must return a list with the same length as `x`. Each element
must be a list of integer vectors where each element indicates the
corresponding elements in `y` where the predicate function is true.

The following predicate generic functions are exported
`sdf_intersects()`, `sdf_contains()`, `sdf_within()`, and
`sdf_crosses()`. It is recommended that you implement these generics,
though not mandatory. Any function that returns a sparse matrix as
described above for two geometry columns can be used.

## Other generics

- `union_geometry()`
- `simplify_geometry()`
- `buffer_geometry()`
- `centroid()`
- `convex_hull()`
- `concave_hull()`

## Implementing `{geos}` generics

``` r
library(geos)
geo <-  as_geos_geometry(guerry$geometry)
```

The first step is to define the `is_geometry()` generic which must
return `TRUE` for your geometry class.

``` r
is_geometry.geos_geometry <- function(x) inherits(x, "geos_geometry")

is_geometry(geo)
#> [1] TRUE
```

Next, we need to implement the bounding box generic. There is not any
bounding box function in geos that I am aware of so we have to implement
our own. The `bounding_box()` generic *must* return a numeric vector of
length 4 with the names `xmin`, `ymin`, `xmax`, and `ymax` in that
order. The bounding box is checked with the internal function
`validate_bbox()`.

``` r
bounding_box.geos_geometry <- function(x) {
  extents <- geos::geos_extent(x)
  apply(extents, 2, min)
}

bounding_box(geo)
#>    xmin    ymin    xmax    ymax 
#>   47680 1703258  172543 1768513
```

For minimal functionality, we need to lastly provide a
`combine_geometry()` method. This is used in the `summarise()` function.

``` r
combine_geometry.geos_geometry <- function(x) {
  geos::geos_make_collection(x)
}

combine_geometry(geo)
#> <geos_geometry[1] with CRS=NA>
#> [1] <GEOMETRYCOLLECTION [47680 1703258...1031401 2677441]>
```

Now we can create an sdf object with only this alone.

``` r
library(sf)
#> Linking to GEOS 3.11.0, GDAL 3.5.3, PROJ 9.1.1; sf_use_s2() is TRUE
#> 
#> Attaching package: 'sf'
#> The following object is masked from 'package:sdf':
#> 
#>     is_geometry
library(dplyr)

geosdf <- as_tibble(guerry) |> 
  mutate(geometry = as_geos_geometry(geometry)) |> 
  as_sdf()

geosdf
#> Geometry Type: geos_geometry
#> Bounding box: xmin: 47680 ymin: 1703258 xmax: 172543 ymax: 1768513
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
#> #   distance <dbl>, area <int>, pop1831 <dbl>, geometry <geos_geom>, and
#> #   abbreviated variable names ¹​ave_id_geo, ²​department, ³​crime_pers,
#> #   ⁴​crime_prop, ⁵​literacy, ⁶​donations
```

Only those three methods we can now use dplyr functionality.

``` r
geosdf |> 
  group_by(code_dept) |> 
  summarise(total_crime = sum(crime_pers))
#> Geometry Type: geos_geometry
#> Bounding box: xmin: 47680 ymin: 1703258 xmax: 172543 ymax: 1768513
#> # A tibble: 85 × 3
#>    code_dept total_crime geometry                                              
#>    <fct>           <int> <geos_geom>                                           
#>  1 01              28870 <GEOMETRYCOLLECTION [785562 2073221...894622 2172530]>
#>  2 02              26226 <GEOMETRYCOLLECTION [645357 2427270...738049 2564568]>
#>  3 03              26747 <GEOMETRYCOLLECTION [595532 2104320...728480 2200625]>
#>  4 04              12935 <GEOMETRYCOLLECTION [853311 1858801...970310 1972682]>
#>  5 05              17488 <GEOMETRYCOLLECTION [845528 1915176...975716 2022608]>
#>  6 07               9474 <GEOMETRYCOLLECTION [720908 1920016...801330 2043510]>
#>  7 08              35203 <GEOMETRYCOLLECTION [722230 2472836...821101 2577475]>
#>  8 09               6173 <GEOMETRYCOLLECTION [476458 1729992...586665 1813083]>
#>  9 10              19602 <GEOMETRYCOLLECTION [677472 2326409...787769 2414830]>
#> 10 11              15647 <GEOMETRYCOLLECTION [547293 1738382...673587 1828670]>
#> # … with 75 more rows
```

This alone is super useful! But we may also want to be able to implement
spatial joins and filters. To do this we need to implement some
predicate functions methods. In this case we will create only the method
for `sdf_intersects()`.

The below function creates a GEOS STRTree which is a type of search tree
that makes speeds up join candidate searches. Then we use the tree to
actually find the intersecting neighbors.

``` r
sdf_intersects.geos_geometry <- function(x, y, ...) {
  rtree <- geos::geos_strtree(y)
  geos::geos_intersects_matrix(x, rtree)
}
```

To use this function let’s sample 25 random points from the originally
sf geometry and join on the region data to it.

``` r
pnt_sample <- sf::st_sample(guerry, 25)

pnts <- as_sdf(
  list(geometry = as_geos_geometry(pnt_sample))
)

sdf_join(pnts, geosdf)
#> Geometry Type: geos_geometry
#> Bounding box: xmin: 271837.44 ymin: 1720409.41 xmax: 271837.44 ymax: 1720409.41
#> # A tibble: 25 × 27
#>    code_dept count ave_id…¹  dept region depar…² crime…³ crime…⁴ liter…⁵ donat…⁶
#>    <fct>     <dbl>    <dbl> <int> <fct>  <fct>     <int>   <int>   <int>   <int>
#>  1 05            1     1802     5 E      Hautes…   17488    8174      69    6962
#>  2 64            1    23572    64 W      Basses…   16722    8533      47    3299
#>  3 36            1    12687    36 C      Indre     32404    7624      17   11315
#>  4 61            1    21456    61 N      Orne      28329    8248      45    9242
#>  5 41            1    14589    41 C      Loir-e…   21292    6017      27    5626
#>  6 43            1    15339    43 C      Haute-…   16170   18043      21    2746
#>  7 47            1    16326    47 W      Lot-et…   22969    8943      31    4432
#>  8 07            1     2249     7 S      Ardeche    9474   10263      27    3188
#>  9 88            1    31810    88 E      Vosges    18835    9044      62    4040
#> 10 40            1    14431    40 W      Landes    17687    6170      28   12059
#> # … with 15 more rows, 17 more variables: infants <int>, suicides <int>,
#> #   main_city <ord>, wealth <int>, commerce <int>, clergy <int>,
#> #   crime_parents <int>, infanticide <int>, donation_clergy <int>,
#> #   lottery <int>, desertion <int>, instruction <int>, prostitutes <int>,
#> #   distance <dbl>, area <int>, pop1831 <dbl>, geometry <geos_geom>, and
#> #   abbreviated variable names ¹​ave_id_geo, ²​department, ³​crime_pers,
#> #   ⁴​crime_prop, ⁵​literacy, ⁶​donations
```
