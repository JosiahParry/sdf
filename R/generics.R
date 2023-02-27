#' @export
combine_geometry <- function(x) UseMethod("combine_geometry")

#' @export
union_geometry <- function(x) UseMethod("union_geometry")

#' @export
simplify_geometry <- function(x, ...) UseMethod("simplify_geometry")

#' @export
buffer_geometry <- function(x, distance, ...) UseMethod("buffer_geometry")

#' @export
bounding_box <- function(x) UseMethod("bounding_box")

#' @export
is_geometry <- function(x) UseMethod("is_geometry")

#' @export
centroid <- function(x) UseMethod("centroid")

#' @export
convex_hull <- function(x) UseMethod("convex_hull")

#' @export
concave_hull <- function(x, concavity, ...) UseMethod("concave_hull")

