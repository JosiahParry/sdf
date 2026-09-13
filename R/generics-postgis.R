# Generics for the operations PostGIS and SedonaDB both define. A backend
# implements what it can and leaves the rest, so a missing one says there is no
# applicable method rather than answering approximately.

# Overlay -----------------------------------------------------------------

#' Overlay two geometry vectors
#'
#' The pairwise overlay operations, `ST_Intersection`, `ST_Difference` and
#' `ST_SymDifference`.
#'
#' @details
#' These pair the two vectors element by element, unlike the predicates, which
#' compare every row of `x` against every row of `y`.
#'
#' @param x,y geometry vectors.
#' @param ... passed to the method.
#' @returns A geometry vector.
#' @examples
#' if (requireNamespace("sf", quietly = TRUE)) {
#'   nc <- sf::st_read(system.file("shape/nc.shp", package = "sf"), quiet = TRUE)
#'   a <- sf::st_geometry(nc)[1:3]
#'   b <- sf::st_buffer(a, 0.05)
#'
#'   st_intersection(a, b)
#'   st_difference(b, a)
#' }
#' @export
#' @rdname overlay
st_intersection <- function(x, y, ...) UseMethod("st_intersection")

#' @export
#' @rdname overlay
st_difference <- function(x, y, ...) UseMethod("st_difference")

#' @export
#' @rdname overlay
st_sym_difference <- function(x, y, ...) UseMethod("st_sym_difference")

# Measurement -------------------------------------------------------------

#' Measurement
#'
#' `ST_Distance` between two vectors and `ST_Perimeter` of one, both returning
#' plain numerics as PostGIS returns floats.
#'
#' @param x,y geometry vectors.
#' @param ... passed to the method.
#' @returns A numeric vector.
#' @examples
#' if (requireNamespace("sf", quietly = TRUE)) {
#'   nc <- sf::st_read(system.file("shape/nc.shp", package = "sf"), quiet = TRUE)
#'   geometry <- sf::st_geometry(nc)
#'
#'   st_distance(geometry[1:3], geometry[4:6])
#'   st_perimeter(geometry[1:3])
#' }
#' @export
#' @rdname measurement
st_distance <- function(x, y, ...) UseMethod("st_distance")

#' @export
#' @rdname measurement
st_perimeter <- function(x, ...) UseMethod("st_perimeter")

# Tests -------------------------------------------------------------------

#' Test each geometry
#'
#' `ST_IsValid`, `ST_IsEmpty` and `ST_IsSimple`, one answer per geometry.
#'
#' @param x a geometry vector.
#' @param ... passed to the method.
#' @returns A logical vector as long as `x`.
#' @examples
#' if (requireNamespace("sf", quietly = TRUE)) {
#'   nc <- sf::st_read(system.file("shape/nc.shp", package = "sf"), quiet = TRUE)
#'   geometry <- sf::st_geometry(nc)[1:3]
#'
#'   st_is_valid(geometry)
#'   st_is_empty(geometry)
#' }
#' @export
#' @rdname tests
st_is_valid <- function(x, ...) UseMethod("st_is_valid")

#' @export
#' @rdname tests
st_is_empty <- function(x, ...) UseMethod("st_is_empty")

#' @export
#' @rdname tests
st_is_simple <- function(x, ...) UseMethod("st_is_simple")

# Accessors ---------------------------------------------------------------

#' Read parts of each geometry
#'
#' `ST_GeometryType`, `ST_Envelope`, `ST_Boundary`, `ST_NumGeometries`,
#' `ST_NumPoints`, `ST_X` and `ST_Y`, one answer per geometry.
#'
#' @details
#' `st_envelope()` is the bounding box of each geometry, unlike [st_extent()],
#' which is the one box covering the whole vector. `st_x()` and `st_y()` are
#' defined for points and give `NA` elsewhere.
#'
#' @param x a geometry vector.
#' @param ... passed to the method.
#' @returns
#' `st_geometry_type()` a character vector. `st_envelope()` and `st_boundary()`
#' a geometry vector. The rest a numeric vector. All as long as `x`.
#' @examples
#' if (requireNamespace("sf", quietly = TRUE)) {
#'   nc <- sf::st_read(system.file("shape/nc.shp", package = "sf"), quiet = TRUE)
#'   geometry <- sf::st_geometry(nc)[1:3]
#'
#'   st_geometry_type(geometry)
#'   st_boundary(geometry)
#' }
#'
#' # sf has no per geometry envelope, geometry count, point count, x or y, so
#' # those are answered by the backends that do
#' if (requireNamespace("geos", quietly = TRUE)) {
#'   pts <- geos::as_geos_geometry(c("POINT (0 1)", "POINT (2 3)"))
#'
#'   st_envelope(pts)
#'   st_num_geometries(pts)
#'   st_x(pts)
#'   st_y(pts)
#' }
#' @export
#' @rdname accessors
st_geometry_type <- function(x, ...) UseMethod("st_geometry_type")

#' @export
#' @rdname accessors
st_envelope <- function(x, ...) UseMethod("st_envelope")

#' @export
#' @rdname accessors
st_boundary <- function(x, ...) UseMethod("st_boundary")

#' @export
#' @rdname accessors
st_num_geometries <- function(x, ...) UseMethod("st_num_geometries")

#' @export
#' @rdname accessors
st_num_points <- function(x, ...) UseMethod("st_num_points")

#' @export
#' @rdname accessors
st_x <- function(x, ...) UseMethod("st_x")

#' @export
#' @rdname accessors
st_y <- function(x, ...) UseMethod("st_y")

# Processing --------------------------------------------------------------

#' Rebuild each geometry
#'
#' `ST_MakeValid`, `ST_Reverse` and `ST_PointOnSurface`, one geometry out per
#' geometry in.
#'
#' @param x a geometry vector.
#' @param ... passed to the method.
#' @returns A geometry vector as long as `x`.
#' @examples
#' if (requireNamespace("sf", quietly = TRUE)) {
#'   nc <- sf::st_read(system.file("shape/nc.shp", package = "sf"), quiet = TRUE)
#'   geometry <- sf::st_geometry(nc)[1:3]
#'
#'   st_make_valid(geometry)
#'   st_point_on_surface(geometry)
#' }
#' @export
#' @rdname processing
st_make_valid <- function(x, ...) UseMethod("st_make_valid")

#' @export
#' @rdname processing
st_reverse <- function(x, ...) UseMethod("st_reverse")

#' @export
#' @rdname processing
st_point_on_surface <- function(x, ...) UseMethod("st_point_on_surface")

#' The DE-9IM relationship between two vectors
#'
#' `ST_Relate`, the pattern every other predicate is a special case of.
#'
#' @details
#' This pairs the two vectors element by element and returns the pattern for
#' each pair, so it is not a predicate [st_join()] can run on.
#'
#' @param x,y geometry vectors.
#' @param ... passed to the method.
#' @returns A character vector of DE-9IM patterns.
#' @examples
#' if (requireNamespace("sf", quietly = TRUE)) {
#'   nc <- sf::st_read(system.file("shape/nc.shp", package = "sf"), quiet = TRUE)
#'   geometry <- sf::st_geometry(nc)
#'
#'   st_relate(geometry[1:3], geometry[2:4])
#' }
#' @export
st_relate <- function(x, y, ...) UseMethod("st_relate")
