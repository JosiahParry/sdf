bounding_box.geos_geometry <- function(x) {
  geos::as_geos_geometry(wk::wk_bbox(geo))
}

combine_geometry.geos_geometry <- function(x) {
  geos::geos_make_collection(x)
}



# Predicates --------------------------------------------------------------


sdf_intersects.geos_geometry <- function(x, y, ...) {
  rtree <- geos::geos_strtree(y)
  geos::geos_intersects_matrix(x, rtree)
}

sdf_intersects.geos_geometry <- function(x, y, ...) {
  rtree <- geos::geos_strtree(x)
  geos::geos_intersects_matrix(y, rtree)
}

sdf_contains.geos_geometry <- function(x, y, ...) {
  rtree <- geos::geos_strtree(x)
  geos::geos_contains_matrix(y, rtree)
}

sdf_within.geos_geometry <- function(x, y, ...) {
  rtree <- geos::geos_strtree(x)
  geos::geos_within_matrix(y, rtree)
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

