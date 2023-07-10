# Required generics -------------------------------------------------------

#' @export
bounding_box.s2_geometry <- function(x) {
  # TODO
}

#' @export
is_geometry.s2_geometry <- function(x) {
  # TODO
}

#' @export
combine_geometry.s2_geometry <- function(x) {
  # TODO
}

# Predicates --------------------------------------------------------------

#' @export
sdf_intersects.s2_geometry <- function(x, y, ...) {
  # TODO
}


#' @export
sdf_contains.s2_geometry <- function(x, y, ...) {
  # TODO
}


#' @export
sdf_within.s2_geometry <- function(x, y, ...) {
  # TODO
}


#' @export
sdf_crosses.s2_geometry <- function(x, y, ...) {
  # TODO
}


#' @export
sdf_covers.s2_geometry <- function(x, y, ...) {
  # TODO
}


#' @export
sdf_covered_by.s2_geometry <- function(x, y, ...) {
  # TODO
}


#' @export
sdf_equals.s2_geometry <- function(x, y, ...) {
  # TODO
}


#' @export
sdf_disjoint.s2_geometry <- function(x, y, ...) {
  # TODO
}


#' @export
sdf_touches.s2_geometry <- function(x, y, ...) {
  # TODO
}


#' @export
sdf_overlaps.s2_geometry <- function(x, y, ...) {
  # TODO
}


# Optional -----------------------------------------------------------------


#' @export
union_geometry.s2_geometry <- function(x) {
  # TODO
}

#' @export
simplify_geometry.s2_geometry <- function(x, ...) {
  # TODO
}

#' @export
buffer_geometry.s2_geometry <- function(x, distance, ...) {
  # TODO
}

#' @export
centroid.s2_geometry <- function(x) {
  # TODO
}

#' @export
convex_hull.s2_geometry <- function(x) {
  # TODO
}

#' @export
concave_hull.s2_geometry <- function(x, concavity, ...) {
  # TODO
}
