
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

The `sdf` generics have been implemented for the `sf`, `geos`, and `s2`
packages. `sdf` will work with those three packages out of the box.

First lets grab an sf object to try converting from.

``` r
library(sf) # so sf methods work
#> Linking to GEOS 3.11.0, GDAL 3.5.3, PROJ 9.1.0; sf_use_s2() is TRUE
library(sdf)

# pull some spatial data
data(guerry, package = "sfdep")
g <- dplyr::select(guerry, code_dept, crime_pers, region)
```

We can then cast the sf object to a spatial data frame.

``` r
# using sf, cast to a spatial data frame
sdf_sf <- as_sdf(g)

sdf_sf
#> Spatial Data Frame
#> Geometry Type: sfc_MULTIPOLYGON
#> Bounding box: xmin: 47680 ymin: 1703258 xmax: 1031401 ymax: 2677441
#> # A tibble: 85 × 4
#>    code_dept crime_pers region                                          geometry
#>    <fct>          <int> <fct>                                     <MULTIPOLYGON>
#>  1 01             28870 E      (((801150 2092615, 800669 2093190, 800688 209543…
#>  2 02             26226 N      (((729326 2521619, 729320 2521230, 729280 251854…
#>  3 03             26747 C      (((710830 2137350, 711746 2136617, 712430 213521…
#>  4 04             12935 E      (((882701 1920024, 882408 1920733, 881778 192120…
#>  5 05             17488 E      (((886504 1922890, 885733 1922978, 885479 192327…
#>  6 07              9474 S      (((747008 1925789, 746630 1925762, 745723 192513…
#>  7 08             35203 N      (((818893 2514767, 818614 2514515, 817900 251446…
#>  8 09              6173 S      (((509103 1747787, 508820 1747513, 508154 174709…
#>  9 10             19602 E      (((775400 2345600, 775068 2345397, 773587 234517…
#> 10 11             15647 S      (((626230 1810121, 626269 1810496, 627494 181132…
#> # ℹ 75 more rows
```

And the same thing goes for geos.

``` r
# using geos
sdf_geos <- as_sdf(
  # convert geometry to rust geometry
  dplyr::mutate(g, geometry = geos::as_geos_geometry(geometry))
)

sdf_geos
#> Spatial Data Frame
#> Geometry Type: geos_geometry
#> Bounding box: xmin: 47680 ymin: 1703258 xmax: 1031401 ymax: 2677441
#> # A tibble: 85 × 4
#>    code_dept crime_pers region geometry                                        
#>    <fct>          <int> <fct>  <geos_geom>                                     
#>  1 01             28870 E      <MULTIPOLYGON [785562 2073221...894622 2172530]>
#>  2 02             26226 N      <MULTIPOLYGON [645357 2427270...738049 2564568]>
#>  3 03             26747 C      <MULTIPOLYGON [595532 2104320...728480 2200625]>
#>  4 04             12935 E      <MULTIPOLYGON [853311 1858801...970310 1972682]>
#>  5 05             17488 E      <MULTIPOLYGON [845528 1915176...975716 2022608]>
#>  6 07              9474 S      <MULTIPOLYGON [720908 1920016...801330 2043510]>
#>  7 08             35203 N      <MULTIPOLYGON [722230 2472836...821101 2577475]>
#>  8 09              6173 S      <MULTIPOLYGON [476458 1729992...586665 1813083]>
#>  9 10             19602 E      <MULTIPOLYGON [677472 2326409...787769 2414830]>
#> 10 11             15647 S      <MULTIPOLYGON [547293 1738382...673587 1828670]>
#> # ℹ 75 more rows
```

The spatial data frame is compatible with dplyr out of the box and it
doesn’t care about your geometry class.

``` r
library(dplyr, warn.conflicts = FALSE)

sdf_sf |> 
  group_by(region) |> 
  summarise(total_crime = sum(crime_pers))
#> Spatial Data Frame
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

sdf_geos |> 
  group_by(region) |> 
  summarise(total_crime = sum(crime_pers))
#> Spatial Data Frame
#> Geometry Type: geos_geometry
#> Bounding box: xmin: 47680 ymin: 1703258 xmax: 1031401 ymax: 2677441
#> # A tibble: 5 × 3
#>   region total_crime geometry                                               
#>   <fct>        <int> <geos_geom>                                            
#> 1 C           385123 <GEOMETRYCOLLECTION [391570 1957191...789713 2438418]> 
#> 2 E           342028 <GEOMETRYCOLLECTION [677472 1858801...1031401 2512709]>
#> 3 N           384061 <GEOMETRYCOLLECTION [290741 2346870...987605 2677441]> 
#> 4 S           203226 <GEOMETRYCOLLECTION [382108 1703258...972280 2043510]> 
#> 5 W           382242 <GEOMETRYCOLLECTION [47680 1757230...529961 2444887]>
```

## Philosophy

There are a number of different geometry types among low-level
libraries. Geometry types should be interchangeable and the type you use
should not be dictated by the libraries you use. All geometries should
be able to convert to and from one another. Some libraries have better
performance, accuracy, or algorithms that can and should be used when
appropriate.

Geospatial and data science more broadly are quickly moving towards a
unified memory format à la arrow. Being able to represent our geometries
in a common memory format enables us to convert to and from anything.
Today, in R, that approach is handled by `{wk}`. In the future, this
will be `{geoarrow}`.

This package is intended to serve as an example of what a spatial data
frame of the future might look like. The geometry column is independent
of the R package itself. All that is required is a number of s3 generic
functions to be implemented.

This is how I hope to see the `{sf}` package. I want to see it as an
enabler of a variety of geometry backends some of which may even be
lazily evaluated (such as a PostGIS backend).

## Required method implementations

The following generics must have an implementation for your geometry
class. The geometry class must be an S3 object / compatible with a data
frame.

- `c()`
- `is_geometry()`
- `bounding_box()`
- `combine_geometry()`

Implementing these generics provides access to dplyr functionality only.

### Default implementations

Since the `wk` package acts as a middle-man between memory formats, we
can use it for default implementations. Any object which is identified
as a vector by `vctrs` and is handleable by `wk` will be minimally
functional.

- `is_geometry(x)` has a default implementation which ensures that `x`
  is a vector and is useable by `wk` via `vctrs::vec_is()` and
  `wk::is_handleable()`.

- `bounding_box()` has default implementation of `wk::wk_bbox()`

- `combine_geometry()` has a default implementation of
  `wk::wk_collection()`

## Spatial joins and filters

The functions `sdf_join()` and `sdf_filter()` have an argument
`predicate` which takes a predicate function—by default
`sdf_intersects()`. For two spatial data frames `x` and `y` the
predicate must return a list with the same length as `x`. Each element
must be a list of integer vectors where each element indicates the
corresponding elements in `y` where the predicate function is true.

The following predicate generic functions are exported:

- `sdf_intersects()`
- `sdf_contains()`
- `sdf_within()`
- `sdf_crosses()`
- `sdf_covers()`
- `sdf_covered_by()`
- `sdf_equals()`
- `sdf_disjoint()`
- `sdf_touches()`
- `sdf_overlaps()`

It is recommended that you implement a few of generics, though not
mandatory. Any function that returns a sparse matrix as described above
for two geometry columns can be used in `sdf_join()` and `sdf_filter()`

## Other generics

There are a number of other generics that are exports. The following
generics are considered to be part of the “main” interface. These are
the functions that are strongly recommended to implement for your
geometry vector class.

- `union_geometry()`
- `simplify_geometry()`
- `buffer_geometry()`
- `centroid()`
- `convex_hull()`
- `concave_hull()`

## Implementing your geometry class

`sdf` provides templates for you to implement your own geometry class.
There are two components:

1.  writing the methods for your class and
2.  registering your method with `sdf`.

To this end there are two templates for you. `use_sdf_template_class()`
will open a new R script with the scaffolding needed to implement your
geometry class.

The first 30 lines of the template are below to illustrate what the
template looks like:

    #> # Generated by {sdf}
    #> 
    #> # Required generics -------------------------------------------------------
    #> # These are the minimal required s3 generics to get basic functionality of
    #> # `sdf`.
    #> 
    #> # Must return TRUE for your class
    #> #' @export
    #> is_geometry.{{class_name}} <- function(x) {
    #>   inherits(x, "{{class_name}}")
    #> }
    #> 
    #> 
    #> # If your class implements a wk handler, the default method will work.
    #> #' @export
    #> bounding_box.{{class_name}} <- function(x) {
    #>   # TODO
    #> }
    #> 
    #> # This must return a single geometry from a vector of geometries
    #> #' @export
    #> combine_geometry.{{class_name}} <- function(x) {
    #>   # TODO
    #> }
    #> 
    #> # Predicates --------------------------------------------------------------
    #> # Predicates are optional, but enable the use of `sdf_join()`. Predicates
    #> # should return a sparse matrix list representation. The elements the list
    #> # are an integer vector indicating the features where the predicate is `TRUE`.
    #> # The vector must be the _row position_.

Secondly the function `use_sdf_template_zzz()` will create the required
`.onLoad()` function call in a `zzz.R` file for you to register your
methods and class.

The first 15 lines are below for an example.

    #> # NOTE: Delete any methods that you have not implemented
    #> 
    #> .onLoad <- function(libname, pkgname) {
    #> 
    #>   # required methods
    #>   vctrs::s3_register("sdf::is_geometry", "{{class_name}}")
    #>   vctrs::s3_register("sdf::bounding_box", "{{class_name}}")
    #>   vctrs::s3_register("sdf::combine_geometry", "{{class_name}}")
    #> 
    #>   # main interface
    #>   vctrs::s3_register("sdf::union_geometry", "{{class_name}}")
    #>   vctrs::s3_register("sdf::simplify_geometry", "{{class_name}}")
    #>   vctrs::s3_register("sdf::buffer_geometry", "{{class_name}}")
    #>   vctrs::s3_register("sdf::centroid", "{{class_name}}")
    #>   vctrs::s3_register("sdf::convex_hull", "{{class_name}}")

### Implementing `{geos}` generics

While there already is a geos implementation, it is worth walking
through how to do so.

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
`combine_geometry()` is intended to combine single geometries into the
multi variety or, at minimum, a geometry collection as done here.

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
library(dplyr)

geosdf <- as_tibble(guerry) |> 
  mutate(geometry = as_geos_geometry(geometry)) |> 
  as_sdf()

geosdf
#> Spatial Data Frame
#> Geometry Type: geos_geometry
#> Bounding box: xmin: 47680 ymin: 1703258 xmax: 172543 ymax: 1768513
#> # A tibble: 85 × 27
#>    code_dept count ave_id_geo  dept region department   crime_pers crime_prop
#>    <fct>     <dbl>      <dbl> <int> <fct>  <fct>             <int>      <int>
#>  1 01            1         49     1 E      Ain               28870      15890
#>  2 02            1        812     2 N      Aisne             26226       5521
#>  3 03            1       1418     3 C      Allier            26747       7925
#>  4 04            1       1603     4 E      Basses-Alpes      12935       7289
#>  5 05            1       1802     5 E      Hautes-Alpes      17488       8174
#>  6 07            1       2249     7 S      Ardeche            9474      10263
#>  7 08            1      35395     8 N      Ardennes          35203       8847
#>  8 09            1       2526     9 S      Ariege             6173       9597
#>  9 10            1      34410    10 E      Aube              19602       4086
#> 10 11            1       2807    11 S      Aude              15647      10431
#> # ℹ 75 more rows
#> # ℹ 19 more variables: literacy <int>, donations <int>, infants <int>,
#> #   suicides <int>, main_city <ord>, wealth <int>, commerce <int>,
#> #   clergy <int>, crime_parents <int>, infanticide <int>,
#> #   donation_clergy <int>, lottery <int>, desertion <int>, instruction <int>,
#> #   prostitutes <int>, distance <dbl>, area <int>, pop1831 <dbl>,
#> #   geometry <geos_geom>
```

With only those three methods we can now use dplyr functionality.

``` r
geosdf |> 
  group_by(code_dept) |> 
  summarise(total_crime = sum(crime_pers))
#> Spatial Data Frame
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
#> # ℹ 75 more rows
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

To use this function let’s sample 25 random points from the original sf
geometry and join on the region data to it.

``` r
pnt_sample <- sf::st_sample(guerry, 25)

pnts <- as_sdf(
  list(geometry = as_geos_geometry(pnt_sample))
)

sdf_join(pnts, geosdf)
#> Spatial Data Frame
#> Geometry Type: geos_geometry
#> Bounding box: xmin: NA ymin: NA xmax: NA ymax: NA
#> # A tibble: 88 × 27
#>    code_dept count ave_id_geo  dept region department    crime_pers crime_prop
#>    <fct>     <dbl>      <dbl> <int> <fct>  <fct>              <int>      <int>
#>  1 22            1      33634    22 W      Cotes-du-Nord      28607       7050
#>  2 <NA>         NA         NA    NA <NA>   <NA>                  NA         NA
#>  3 <NA>         NA         NA    NA <NA>   <NA>                  NA         NA
#>  4 25            1       7482    25 E      Doubs              11560       5914
#>  5 10            1      34410    10 E      Aube               19602       4086
#>  6 <NA>         NA         NA    NA <NA>   <NA>                  NA         NA
#>  7 <NA>         NA         NA    NA <NA>   <NA>                  NA         NA
#>  8 05            1       1802     5 E      Hautes-Alpes       17488       8174
#>  9 <NA>         NA         NA    NA <NA>   <NA>                  NA         NA
#> 10 <NA>         NA         NA    NA <NA>   <NA>                  NA         NA
#> # ℹ 78 more rows
#> # ℹ 19 more variables: literacy <int>, donations <int>, infants <int>,
#> #   suicides <int>, main_city <ord>, wealth <int>, commerce <int>,
#> #   clergy <int>, crime_parents <int>, infanticide <int>,
#> #   donation_clergy <int>, lottery <int>, desertion <int>, instruction <int>,
#> #   prostitutes <int>, distance <dbl>, area <int>, pop1831 <dbl>,
#> #   geometry <geos_geom>
```
