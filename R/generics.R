# Note that default implementations will use {wk}
# so anything that implements a wk handler can be used the
# generic is not implemented it'll return a wk geometry


# Required generics -------------------------------------------------------

#' @export
bounding_box <- function(x) UseMethod("bounding_box")

bounding_box.default <- function(x) {
  wk::wk_bbox(x)
}

#' @export
is_geometry <- function(x) UseMethod("is_geometry")

is_geometry.default <- function(x) {
  vctrs::vec_is(x) && wk::is_handleable(x)
}

#' @export
combine_geometry <- function(x) UseMethod("combine_geometry")


# Optional generics -------------------------------------------------------

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


# -------------------------------------------------------------------------

# lenght
# is empty
# is_valid
# is within distance
# nearest feature
# relate
# voronoi

