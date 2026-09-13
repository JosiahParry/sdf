
#' @export
is_geometry.geos_geometry <- function(x) {
  TRUE
}

# bounding_box() is not defined here: geos_geometry implements a wk handler, so
# the default already gives the right answer.

#' @export
combine_geometry.geos_geometry <- function(x) {
  geos::geos_make_collection(x)
}


# Predicates --------------------------------------------------------------
# geos_*_matrix(geom, tree) tests the predicate with `geom` on the left and the
# tree items on the right, so the tree is built from `y` and `x` is the query.
# Building it from `x` instead returns the transpose.

#' @export
sdf_intersects.geos_geometry <- function(x, y, ...) {
  geos::geos_intersects_matrix(x, geos::geos_strtree(y))
}

#' @export
sdf_contains.geos_geometry <- function(x, y, ...) {
  geos::geos_contains_matrix(x, geos::geos_strtree(y))
}

#' @export
sdf_within.geos_geometry <- function(x, y, ...) {
  geos::geos_within_matrix(x, geos::geos_strtree(y))
}

#' @export
sdf_crosses.geos_geometry <- function(x, y, ...) {
  geos::geos_crosses_matrix(x, geos::geos_strtree(y))
}

#' @export
sdf_covers.geos_geometry <- function(x, y, ...) {
  geos::geos_covers_matrix(x, geos::geos_strtree(y))
}

#' @export
sdf_covered_by.geos_geometry <- function(x, y, ...) {
  geos::geos_covered_by_matrix(x, geos::geos_strtree(y))
}

#' @export
sdf_equals.geos_geometry <- function(x, y, ...) {
  geos::geos_equals_matrix(x, geos::geos_strtree(y))
}

#' @export
sdf_disjoint.geos_geometry <- function(x, y, ...) {
  geos::geos_disjoint_matrix(x, geos::geos_strtree(y))
}

#' @export
sdf_touches.geos_geometry <- function(x, y, ...) {
  geos::geos_touches_matrix(x, geos::geos_strtree(y))
}

#' @export
sdf_overlaps.geos_geometry <- function(x, y, ...) {
  geos::geos_overlaps_matrix(x, geos::geos_strtree(y))
}


# Algorithms --------------------------------------------------------------

#' @export
union_geometry.geos_geometry <- function(x) {
  geos::geos_unary_union(geos::geos_make_collection(x))
}

#' @export
simplify_geometry.geos_geometry <- function(x, tolerance, ...) {
  geos::geos_simplify(x, tolerance)
}

#' @export
buffer_geometry.geos_geometry <- function(x, distance, ...) {
  geos::geos_buffer(x, distance, ...)
}

#' @export
centroid.geos_geometry <- function(x) {
  geos::geos_centroid(x)
}

#' @export
convex_hull.geos_geometry <- function(x) {
  geos::geos_convex_hull(x)
}

#' @export
concave_hull.geos_geometry <- function(x, concavity, ...)  {
  geos::geos_concave_hull(x, concavity, ...)
}

