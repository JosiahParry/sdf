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

#' @export
sdf_covers <- function(x, y, ...) UseMethod("sdf_covers")

#' @export
sdf_covered_by <- function(x, y, ...) UseMethod("sdf_covered_by")

#' @export
sdf_equals <- function(x, y, ...) UseMethod("sdf_equals")

#' @export
sdf_disjoint <- function(x, y, ...) UseMethod("sdf_disjoint")

#' @export
sdf_touches <- function(x, y, ...) UseMethod("sdf_touches")

#' @export
sdf_overlaps <- function(x, y, ...) UseMethod("sdf_overlaps")

