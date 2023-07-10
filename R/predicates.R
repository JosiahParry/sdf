#' Spatial Predicate Functions
#' Predicates are optional, but enable the use of `sdf_join()`.
#'
#'
#' Predicates should return a sparse matrix list representation. The elements the list
#' are an integer vector indicating the features where the predicate is `TRUE`.
#' The vector must be the _row position_.

#' @export
#' @rdname predicates
sdf_intersects <- function(x, y, ...) UseMethod("sdf_intersects")

#' @export
#' @rdname predicates
sdf_contains <- function(x, y, ...) UseMethod("sdf_contains")

#' @export
#' @rdname predicates
sdf_within <- function(x, y, ...) UseMethod("sdf_within")

#' @export
#' @rdname predicates
sdf_crosses <- function(x, y, ...) UseMethod("sdf_crosses")

#' @export
#' @rdname predicates
sdf_covers <- function(x, y, ...) UseMethod("sdf_covers")

#' @export
#' @rdname predicates
sdf_covered_by <- function(x, y, ...) UseMethod("sdf_covered_by")

#' @export
#' @rdname predicates
sdf_equals <- function(x, y, ...) UseMethod("sdf_equals")

#' @export
#' @rdname predicates
sdf_disjoint <- function(x, y, ...) UseMethod("sdf_disjoint")

#' @export
#' @rdname predicates
sdf_touches <- function(x, y, ...) UseMethod("sdf_touches")

#' @export
#' @rdname predicates
sdf_overlaps <- function(x, y, ...) UseMethod("sdf_overlaps")

