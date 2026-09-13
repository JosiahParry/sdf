# Validate bounding box utility
validate_bbox <- function(x) {
  stopifnot(
    is.numeric(x),
    length(x) == 4,
    names(x) == c("xmin", "ymin", "xmax", "ymax")
  )
  x
}

#' Geometry accessor
#'
#' Pulls the geometry column out of a spatial data frame, whatever it is named.
#'
#' @param x a spatial data frame.
#' @returns The geometry vector of `x`.
#' @examples
#' if (requireNamespace("sf", quietly = TRUE)) {
#'   nc <- sf::st_read(system.file("shape/nc.shp", package = "sf"), quiet = TRUE)
#'   x <- as_sdf(tibble::tibble(
#'     name = as.character(nc$NAME),
#'     geometry = sf::st_geometry(nc)
#'   ))
#'
#'   sdf_geometry(x)
#' }
#' @export
sdf_geometry <- function(x) {
  x[[attr(x, "geom_column")]]
}

#' @export
is_geometry.default <- function(x) {
  # a catch all for sfc, geos, and rust geometries.
  inherits(
    x,
    c("sfc",
      "geos_geometry",
      "rs_POINT", "rs_MULTIPOINT",
      "rs_POLYGON", "rs_MULTIPOLYGON",
      "rs_LINESTRING", "rs_MULTILINESTRING")
  )
}
