# Note that default implementations will use {wk}
# so anything that implements a wk handler can be used the
# generic is not implemented it'll return a wk geometry


# Required generics -------------------------------------------------------

#' @export
bounding_box <- function(x) UseMethod("bounding_box")

#' @export
bounding_box.default <- function(x) {
  wk::wk_bbox(x)
}

#' @export
is_geometry <- function(x) UseMethod("is_geometry")

#' @export
is_geometry.default <- function(x) {
  vctrs::vec_is(x) && wk::is_handleable(x)
}

#' @export
combine_geometry <- function(x) UseMethod("combine_geometry")



# Main interface ----------------------------------------------------------
# These are the minimum suggested, but still optional, generics to implement

#' @export
union_geometry <- function(x) UseMethod("union_geometry")

#' @export
simplify_geometry <- function(x, ...) UseMethod("simplify_geometry")

#' @export
buffer_geometry <- function(x, distance, ...) UseMethod("buffer_geometry")

#' @export
centroid <- function(x) UseMethod("centroid")

#' @export
convex_hull <- function(x) UseMethod("convex_hull")

#' @export
concave_hull <- function(x, concavity, ...) UseMethod("concave_hull")



# Additional utilities ----------------------------------------------------
# these are optional generics to implement that are very common and could be
# useful to implement. But less important than the main interface.

#' @export
sdf_length <- function(x, ...) UseMethod("sdf_length")

#' @export
sdf_area <- function(x, ...) UseMethod("sdf_area")

# possible others to implement:

# is empty
# is_valid
# is within distance
# nearest feature
# relate
# voronoi

