# Spatial Predicate Functions
# These generics are used to define the relationships used in
# spatial filters and joins

#' @export
sdf_intersects <- function(x, y, ...) UseMethod("sdf_intersects")

#' @export
sdf_contains <- function(x, y, ...) UseMethod("sdf_contains")

#' @export
sdf_within <- function(x, y, ...) UseMethod("sdf_within")

#' @export
sdf_crosses <- function(x, y, ...) UseMethod("sdf_crosses")

# sf compat ---------------------------------------------------------------
sdf_intersects.sfc <- function(x, y, ...) sf::st_intersects(x, y, ...)
sdf_contains.sfc <- function(x, y, ...) sf::st_contains(x, y, ...)
sdf_within.sfc <- function(x, y, ...) sf::st_within(x, y, ...)
sdf_crosses.sfc <- function(x, y, ...) sf::st_crosses(x, y, ...)


# geos compat -------------------------------------------------------------
#
# sdf_intersects.geos_geometry <- function(x, y, ...) {
#   rtree <- geos::geos_strtree(x)
#   geos::geos_intersects_matrix(y, rtree)
# }
#
# sdf_contains.geos_geometry <- function(x, y, ...) {
#   rtree <- geos::geos_strtree(x)
#   geos::geos_contains_matrix(y, rtree)
# }
#
# sdf_within.geos_geometry <- function(x, y, ...) {
#   rtree <- geos::geos_strtree(x)
#   geos::geos_within_matrix(y, rtree)
# }
#
