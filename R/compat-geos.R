
#' @export
is_geometry.geos_geometry <- function(x) {
  TRUE
}

# st_extent() is not defined here: geos_geometry implements a wk handler, so
# the default already gives the right answer.

# geos_make_collection() always builds a GEOMETRYCOLLECTION, so the type
# PostGIS would give is asked for explicitly. The parts are unnested first: a
# multipolygon inside a multipolygon is not a geometry.
#' @export
st_collect.geos_geometry <- function(x) {
  geos::geos_make_collection(
    geos::geos_unnest(x, keep_multi = FALSE),
    type_id = collect_type(x)
  )
}


# Predicates --------------------------------------------------------------
# geos_*_matrix(geom, tree) tests the predicate with `geom` on the left and the
# tree items on the right, so the tree is built from `y` and `x` is the query.
# Building it from `x` instead returns the transpose.

#' @export
st_intersects.geos_geometry <- function(x, y, ...) {
  geos::geos_intersects_matrix(x, geos::geos_strtree(y))
}

#' @export
st_contains.geos_geometry <- function(x, y, ...) {
  geos::geos_contains_matrix(x, geos::geos_strtree(y))
}

#' @export
st_within.geos_geometry <- function(x, y, ...) {
  geos::geos_within_matrix(x, geos::geos_strtree(y))
}

#' @export
st_crosses.geos_geometry <- function(x, y, ...) {
  geos::geos_crosses_matrix(x, geos::geos_strtree(y))
}

#' @export
st_covers.geos_geometry <- function(x, y, ...) {
  geos::geos_covers_matrix(x, geos::geos_strtree(y))
}

#' @export
st_covered_by.geos_geometry <- function(x, y, ...) {
  geos::geos_covered_by_matrix(x, geos::geos_strtree(y))
}

#' @export
st_equals.geos_geometry <- function(x, y, ...) {
  geos::geos_equals_matrix(x, geos::geos_strtree(y))
}

#' @export
st_disjoint.geos_geometry <- function(x, y, ...) {
  geos::geos_disjoint_matrix(x, geos::geos_strtree(y))
}

#' @export
st_touches.geos_geometry <- function(x, y, ...) {
  geos::geos_touches_matrix(x, geos::geos_strtree(y))
}

#' @export
st_overlaps.geos_geometry <- function(x, y, ...) {
  geos::geos_overlaps_matrix(x, geos::geos_strtree(y))
}


# Algorithms --------------------------------------------------------------

#' @export
st_union.geos_geometry <- function(x) {
  geos::geos_unary_union(geos::geos_make_collection(x))
}

#' @export
st_simplify.geos_geometry <- function(x, tolerance, ...) {
  geos::geos_simplify(x, tolerance)
}

#' @export
st_buffer.geos_geometry <- function(x, distance, ...) {
  geos::geos_buffer(x, distance, ...)
}

#' @export
st_centroid.geos_geometry <- function(x) {
  geos::geos_centroid(x)
}

#' @export
st_convex_hull.geos_geometry <- function(x) {
  geos::geos_convex_hull(x)
}

#' @export
st_concave_hull.geos_geometry <- function(x, concavity, ...)  {
  geos::geos_concave_hull(x, concavity, ...)
}


# PostGIS operations geos also has ----------------------------------------

#' @export
st_intersection.geos_geometry <- function(x, y, ...) {
  geos::geos_intersection(x, y, ...)
}

#' @export
st_difference.geos_geometry <- function(x, y, ...) {
  geos::geos_difference(x, y, ...)
}

#' @export
st_sym_difference.geos_geometry <- function(x, y, ...) {
  geos::geos_sym_difference(x, y, ...)
}

#' @export
st_distance.geos_geometry <- function(x, y, ...) geos::geos_distance(x, y, ...)

#' @export
st_is_valid.geos_geometry <- function(x, ...) geos::geos_is_valid(x, ...)

#' @export
st_is_empty.geos_geometry <- function(x, ...) geos::geos_is_empty(x, ...)

#' @export
st_is_simple.geos_geometry <- function(x, ...) geos::geos_is_simple(x, ...)

#' @export
st_geometry_type.geos_geometry <- function(x, ...) {
  as.character(geos::geos_type(x, ...))
}

#' @export
st_envelope.geos_geometry <- function(x, ...) geos::geos_envelope(x, ...)

#' @export
st_boundary.geos_geometry <- function(x, ...) geos::geos_boundary(x, ...)

#' @export
st_num_geometries.geos_geometry <- function(x, ...) {
  geos::geos_num_geometries(x, ...)
}

#' @export
st_x.geos_geometry <- function(x, ...) geos::geos_x(x, ...)

#' @export
st_y.geos_geometry <- function(x, ...) geos::geos_y(x, ...)

#' @export
st_make_valid.geos_geometry <- function(x, ...) geos::geos_make_valid(x, ...)

#' @export
st_reverse.geos_geometry <- function(x, ...) geos::geos_reverse(x, ...)

#' @export
st_point_on_surface.geos_geometry <- function(x, ...) {
  geos::geos_point_on_surface(x, ...)
}

#' @export
st_relate.geos_geometry <- function(x, y, ...) geos::geos_relate(x, y, ...)

# geos has no matrix form of geos_is_within_distance(), so there is no
# st_dwithin() method here: building one would mean testing every pair
