# Note that default implementations will use {wk}
# so anything that implements a wk handler can be used the
# generic is not implemented it'll return a wk geometry


# Required generics -------------------------------------------------------

#' Required generics
#'
#' The three generics a geometry vector must implement to work as the geometry
#' column of a spatial data frame.
#'
#' @details
#' `is_geometry()` must return `TRUE` for the class. `st_extent()` must
#' return a numeric vector named `xmin`, `ymin`, `xmax`, `ymax` covering the
#' whole vector. `st_collect()` must return the vector as a single geometry,
#' following PostGIS `ST_Collect`: a `MULTI*` where the parts agree on a type
#' and a `GEOMETRYCOLLECTION` where they do not. The defaults use wk, so a
#' class with a wk handler already has all three.
#'
#' @param x a geometry vector.
#' @returns
#' `is_geometry()` a single logical. `st_extent()` a named numeric vector of
#' length 4. `st_collect()` a geometry vector of length 1.
#' @examples
#' if (requireNamespace("sf", quietly = TRUE)) {
#'   nc <- sf::st_read(system.file("shape/nc.shp", package = "sf"), quiet = TRUE)
#'   geometry <- sf::st_geometry(nc)
#'
#'   is_geometry(geometry)
#'   st_extent(geometry)
#'   st_collect(geometry)
#' }
#' @export
#' @rdname generics
is_geometry <- function(x) UseMethod("is_geometry")

#' @export
is_geometry.default <- function(x) {
  vctrs::vec_is(x) && wk::is_handleable(x)
}

#' @export
#' @rdname generics
st_extent <- function(x) UseMethod("st_extent")

#' @export
st_extent.default <- function(x) {
  unlist(wk::wk_bbox(x))
}

#' @export
#' @rdname generics
st_collect <- function(x) UseMethod("st_collect")

#' @export
st_collect.default <- function(x) {
  wk::wk_collection(wk::wk_flatten(x), geometry_type = collect_type(x))
}

# PostGIS collects into a Multi* when the parts agree on a type and into a
# geometry collection when they do not. A point and a multipoint agree, both
# collecting into a multipoint, and so on for lines and polygons. The parts are
# flattened first: a multipolygon inside a multipolygon is not a geometry.
collect_type <- function(x) {
  types <- unique(wk::wk_meta(x)$geometry_type)
  types <- types[!is.na(types)]

  # point, linestring, polygon, multipoint, multilinestring, multipolygon
  multi <- unique(c(4L, 5L, 6L, 4L, 5L, 6L)[types])

  if (length(multi) == 1L && !is.na(multi)) {
    multi
  } else {
    wk::wk_geometry_type("geometrycollection")
  }
}



# Main interface ----------------------------------------------------------
# These are the minimum suggested, but still optional, generics to implement

#' Primary interface
#'
#' Optional but strongly suggested: the operations a spatial data frame is
#' usually asked for.
#'
#' @param x a geometry vector.
#' @param distance the buffer distance.
#' @param concavity how tightly the hull follows the points.
#' @param ... passed to the method.
#' @returns A geometry vector. `st_union()` returns one of length 1.
#' @examples
#' if (requireNamespace("sf", quietly = TRUE)) {
#'   nc <- sf::st_read(system.file("shape/nc.shp", package = "sf"), quiet = TRUE)
#'   geometry <- sf::st_geometry(nc)
#'
#'   st_centroid(geometry)
#'   st_convex_hull(geometry)
#' }
#' @export
#' @rdname primary
st_union <- function(x) UseMethod("st_union")

#' @export
#' @rdname primary
st_simplify <- function(x, ...) UseMethod("st_simplify")

#' @export
#' @rdname primary
st_buffer <- function(x, distance, ...) UseMethod("st_buffer")

#' @export
#' @rdname primary
st_centroid <- function(x) UseMethod("st_centroid")

#' @export
#' @rdname primary
st_convex_hull <- function(x) UseMethod("st_convex_hull")

#' @export
#' @rdname primary
st_concave_hull <- function(x, concavity, ...) UseMethod("st_concave_hull")



# Additional utilities ----------------------------------------------------
# these are optional generics to implement that are very common and could be
# useful to implement. But less important than the main interface.

#' Optional generics
#'
#' Common measures a backend may implement.
#'
#' @param x a geometry vector.
#' @param ... passed to the method.
#' @returns A numeric vector as long as `x`.
#' @examples
#' if (requireNamespace("sf", quietly = TRUE)) {
#'   nc <- sf::st_read(system.file("shape/nc.shp", package = "sf"), quiet = TRUE)
#'
#'   st_area(sf::st_geometry(nc))
#' }
#' @export
#' @rdname optional
st_length <- function(x, ...) UseMethod("st_length")

#' @export
#' @rdname optional
st_area <- function(x, ...) UseMethod("st_area")

# possible others to implement:

# is empty
# is_valid
# is within distance
# nearest feature
# relate
# voronoi

