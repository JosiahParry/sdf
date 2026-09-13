# Note that default implementations will use {wk}
# so anything that implements a wk handler can be used the
# generic is not implemented it'll return a wk geometry


# Required generics -------------------------------------------------------

#' Required generics
#'
#' The three generics a geometry vector must implement to work as the geometry
#' column of a spatial data frame.
#'
#' @details
#' `is_geometry()` must return `TRUE` for the class. `bounding_box()` must
#' return a numeric vector named `xmin`, `ymin`, `xmax`, `ymax` covering the
#' whole vector. `combine_geometry()` must return the vector as a single
#' geometry. The defaults use wk, so a class with a wk handler already has all
#' three.
#'
#' @param x a geometry vector.
#' @returns
#' `is_geometry()` a single logical. `bounding_box()` a named numeric vector of
#' length 4. `combine_geometry()` a geometry vector of length 1.
#' @examples
#' if (requireNamespace("sf", quietly = TRUE)) {
#'   nc <- sf::st_read(system.file("shape/nc.shp", package = "sf"), quiet = TRUE)
#'   geometry <- sf::st_geometry(nc)
#'
#'   is_geometry(geometry)
#'   bounding_box(geometry)
#'   combine_geometry(geometry)
#' }
#' @export
#' @rdname generics
is_geometry <- function(x) UseMethod("is_geometry")

#' @export
is_geometry.default <- function(x) {
  vctrs::vec_is(x) && wk::is_handleable(x)
}

#' @export
#' @rdname generics
bounding_box <- function(x) UseMethod("bounding_box")

#' @export
bounding_box.default <- function(x) {
  unlist(wk::wk_bbox(x))
}

#' @export
#' @rdname generics
combine_geometry <- function(x) UseMethod("combine_geometry")

#' @export
combine_geometry.default <- function(x) wk::wk_collection(x)



# Main interface ----------------------------------------------------------
# These are the minimum suggested, but still optional, generics to implement

#' Primary interface
#'
#' Optional but strongly suggested: the operations a spatial data frame is
#' usually asked for.
#'
#' @param x a geometry vector.
#' @param distance the buffer distance.
#' @param concavity how tightly the hull follows the points.
#' @param ... passed to the method.
#' @returns A geometry vector. `union_geometry()` returns one of length 1.
#' @examples
#' if (requireNamespace("sf", quietly = TRUE)) {
#'   nc <- sf::st_read(system.file("shape/nc.shp", package = "sf"), quiet = TRUE)
#'   geometry <- sf::st_geometry(nc)
#'
#'   centroid(geometry)
#'   convex_hull(geometry)
#' }
#' @export
#' @rdname primary
union_geometry <- function(x) UseMethod("union_geometry")

#' @export
#' @rdname primary
simplify_geometry <- function(x, ...) UseMethod("simplify_geometry")

#' @export
#' @rdname primary
buffer_geometry <- function(x, distance, ...) UseMethod("buffer_geometry")

#' @export
#' @rdname primary
centroid <- function(x) UseMethod("centroid")

#' @export
#' @rdname primary
convex_hull <- function(x) UseMethod("convex_hull")

#' @export
#' @rdname primary
concave_hull <- function(x, concavity, ...) UseMethod("concave_hull")



# Additional utilities ----------------------------------------------------
# these are optional generics to implement that are very common and could be
# useful to implement. But less important than the main interface.

#' Optional generics
#'
#' Common measures a backend may implement.
#'
#' @param x a geometry vector.
#' @param ... passed to the method.
#' @returns A numeric vector as long as `x`.
#' @examples
#' if (requireNamespace("sf", quietly = TRUE)) {
#'   nc <- sf::st_read(system.file("shape/nc.shp", package = "sf"), quiet = TRUE)
#'
#'   sdf_area(sf::st_geometry(nc))
#' }
#' @export
#' @rdname optional
sdf_length <- function(x, ...) UseMethod("sdf_length")

#' @export
#' @rdname optional
sdf_area <- function(x, ...) UseMethod("sdf_area")

# possible others to implement:

# is empty
# is_valid
# is within distance
# nearest feature
# relate
# voronoi

