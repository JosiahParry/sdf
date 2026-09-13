#' Spatial predicates
#'
#' Each returns, for every row of `x`, the row positions of `y` that the
#' relationship holds for. Implementing them is optional, but they are what
#' [sdf_join()] and [sdf_filter()] run on.
#'
#' @details
#' A method returns a list as long as `x`, whose elements are the row positions
#' of `y`. Integer is the natural type but doubles are accepted, and an element
#' of length zero means no match. An sf `sgbp` already has this shape.
#'
#' @param x,y geometry vectors.
#' @param ... passed to the method.
#' @returns A list as long as `x`, each element the row positions of `y` that
#'   match.
#' @examples
#' if (requireNamespace("sf", quietly = TRUE)) {
#'   nc <- sf::st_read(system.file("shape/nc.shp", package = "sf"), quiet = TRUE)
#'   geometry <- sf::st_geometry(nc)
#'
#'   sdf_intersects(geometry[1:3], geometry[1:10])
#' }
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

