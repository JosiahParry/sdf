# Spatial Predicate Functions
# These generics are used to define the relationships used in
# spatial filters and joins

#' @export
sdf_intersects <- function(x, y, ...) UseMethod("sdf_intersects")

#' @export
sdf_contains <- function(x, y, ...) UseMethod("sdf_contains")

#' @export
sdf_within <- function(x, y, ...) UseMethod("sdf_within")




# sf compat ---------------------------------------------------------------
sdf_intersects.sfc <- function(x, y, ...) sf::st_intersects(x, y, ...)
sdf_contains.sfc <- function(x, y, ...) sf::st_contains(x, y, ...)
sdf_within.sfc <- function(x, y, ...) sf::st_within(x, y, ...)
