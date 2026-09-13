# sf backend. Every method needs @export so roxygen registers it: without that
# they are only reachable from inside this namespace and not for a user calling
# sdf_intersects() on an sfc.

# Required generics -------------------------------------------------------

#' @export
is_geometry.sfc <- function(x) {
  TRUE
}

#' @export
bounding_box.sfc <- function(x) {
  bbox <- sf::st_bbox(x)
  stats::setNames(as.numeric(bbox), c("xmin", "ymin", "xmax", "ymax"))
}

#' @export
combine_geometry.sfc <- function(x) sf::st_combine(x)

# Predicates --------------------------------------------------------------

#' @export
sdf_intersects.sfc <- function(x, y, ...) sf::st_intersects(x, y, ...)

#' @export
sdf_contains.sfc <- function(x, y, ...) sf::st_contains(x, y, ...)

#' @export
sdf_within.sfc <- function(x, y, ...) sf::st_within(x, y, ...)

#' @export
sdf_crosses.sfc <- function(x, y, ...) sf::st_crosses(x, y, ...)

#' @export
sdf_covers.sfc <- function(x, y, ...) sf::st_covers(x, y, ...)

#' @export
sdf_covered_by.sfc <- function(x, y, ...) sf::st_covered_by(x, y, ...)

#' @export
sdf_equals.sfc <- function(x, y, ...) sf::st_equals(x, y, ...)

#' @export
sdf_disjoint.sfc <- function(x, y, ...) sf::st_disjoint(x, y, ...)

#' @export
sdf_touches.sfc <- function(x, y, ...) sf::st_touches(x, y, ...)

#' @export
sdf_overlaps.sfc <- function(x, y, ...) sf::st_overlaps(x, y, ...)

# Optional ----------------------------------------------------------------

#' @export
union_geometry.sfc <- function(x) sf::st_union(x)

#' @export
simplify_geometry.sfc <- function(x, tolerance, ...) {
  sf::st_simplify(x, dTolerance = tolerance, ...)
}

#' @export
buffer_geometry.sfc <- function(x, distance, ...) sf::st_buffer(x, distance, ...)

#' @export
centroid.sfc <- function(x) sf::st_centroid(x)

#' @export
convex_hull.sfc <- function(x) sf::st_convex_hull(x)

#' @export
concave_hull.sfc <- function(x, concavity, ...) {
  sf::st_concave_hull(x, ratio = concavity, ...)
}

#' @export
sdf_area.sfc <- function(x, ...) as.numeric(sf::st_area(x, ...))

#' @export
sdf_length.sfc <- function(x, ...) as.numeric(sf::st_length(x, ...))
