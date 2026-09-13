# sf backend. Every method needs @export so roxygen registers it: without that
# they are only reachable from inside this namespace and not for a user calling
# st_intersects() on an sfc.
#
# sdf masks these names, so where sf's function is itself a generic we cannot
# reach it by name: sf's dispatch searches the environment it was called from,
# finds the method below, and recurses until the stack runs out. Those go
# through sf_method() to sf's registered method instead. Where sf's function is
# plain, as most of the predicates are, sf::f() is safe.

sf_method <- function(generic, class = "sfc") {
  utils::getS3method(generic, class, envir = asNamespace("sf"))
}

# Required generics -------------------------------------------------------

#' @export
is_geometry.sfc <- function(x) {
  TRUE
}

#' @export
st_extent.sfc <- function(x) {
  bbox <- sf::st_bbox(x)
  stats::setNames(as.numeric(bbox), c("xmin", "ymin", "xmax", "ymax"))
}

#' @export
st_collect.sfc <- function(x) sf::st_combine(x)

# Predicates --------------------------------------------------------------

#' @export
st_intersects.sfc <- function(x, y, ...) sf_method("st_intersects")(x, y, ...)

#' @export
st_contains.sfc <- function(x, y, ...) sf::st_contains(x, y, ...)

#' @export
st_within.sfc <- function(x, y, ...) sf::st_within(x, y, ...)

#' @export
st_crosses.sfc <- function(x, y, ...) sf::st_crosses(x, y, ...)

#' @export
st_covers.sfc <- function(x, y, ...) sf::st_covers(x, y, ...)

#' @export
st_covered_by.sfc <- function(x, y, ...) sf::st_covered_by(x, y, ...)

#' @export
st_equals.sfc <- function(x, y, ...) sf::st_equals(x, y, ...)

#' @export
st_disjoint.sfc <- function(x, y, ...) sf::st_disjoint(x, y, ...)

#' @export
st_touches.sfc <- function(x, y, ...) sf::st_touches(x, y, ...)

#' @export
st_overlaps.sfc <- function(x, y, ...) sf::st_overlaps(x, y, ...)

# Optional ----------------------------------------------------------------

#' @export
st_union.sfc <- function(x) sf_method("st_union")(x)

#' @export
st_simplify.sfc <- function(x, tolerance, ...) {
  sf_method("st_simplify")(x, dTolerance = tolerance, ...)
}

#' @export
st_buffer.sfc <- function(x, distance, ...) sf_method("st_buffer")(x, distance, ...)

#' @export
st_centroid.sfc <- function(x) sf_method("st_centroid")(x)

#' @export
st_convex_hull.sfc <- function(x) sf_method("st_convex_hull")(x)

#' @export
st_concave_hull.sfc <- function(x, concavity, ...) {
  sf_method("st_concave_hull")(x, ratio = concavity, ...)
}

#' @export
st_area.sfc <- function(x, ...) as.numeric(sf_method("st_area")(x, ...))

#' @export
st_length.sfc <- function(x, ...) as.numeric(sf::st_length(x, ...))

# PostGIS operations sf also has ------------------------------------------

#' @export
st_dwithin.sfc <- function(x, y, distance, ...) {
  sf::st_is_within_distance(x, y, dist = distance, ...)
}

#' @export
st_intersection.sfc <- function(x, y, ...) {
  sf_method("st_intersection")(x, y, ...)
}

#' @export
st_difference.sfc <- function(x, y, ...) sf_method("st_difference")(x, y, ...)

#' @export
st_sym_difference.sfc <- function(x, y, ...) {
  sf_method("st_sym_difference")(x, y, ...)
}

#' @export
st_distance.sfc <- function(x, y, ...) {
  as.numeric(sf::st_distance(x, y, by_element = TRUE, ...))
}

#' @export
st_perimeter.sfc <- function(x, ...) as.numeric(sf::st_perimeter(x, ...))

#' @export
st_is_valid.sfc <- function(x, ...) sf_method("st_is_valid")(x, ...)

#' @export
st_is_empty.sfc <- function(x, ...) sf::st_is_empty(x, ...)

#' @export
st_is_simple.sfc <- function(x, ...) sf::st_is_simple(x, ...)

#' @export
st_geometry_type.sfc <- function(x, ...) {
  as.character(sf::st_geometry_type(x, ...))
}

#' @export
st_boundary.sfc <- function(x, ...) sf_method("st_boundary")(x, ...)

# sf has no per geometry envelope, geometry count, point count, x or y, so
# those are left to the backends that do

#' @export
st_make_valid.sfc <- function(x, ...) sf_method("st_make_valid")(x, ...)

#' @export
st_reverse.sfc <- function(x, ...) sf_method("st_reverse")(x, ...)

#' @export
st_point_on_surface.sfc <- function(x, ...) {
  sf_method("st_point_on_surface")(x, ...)
}

# sf::st_relate() builds the whole matrix, every row of `x` against every row
# of `y`. PostGIS pairs them, so the pairs are asked for one at a time rather
# than computing n squared patterns and throwing all but the diagonal away.
#' @export
st_relate.sfc <- function(x, y, ...) {
  pairs <- vctrs::vec_recycle_common(x = x, y = y)

  vapply(
    seq_along(pairs$x),
    function(i) sf::st_relate(pairs$x[i], pairs$y[i], ...)[[1]],
    character(1)
  )
}
