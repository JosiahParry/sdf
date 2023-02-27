# Validate bounding box utility
validate_bbox <- function(x) {
  stopifnot(
    is.numeric(x),
    length(x) == 4,
    names(x) == c("xmin", "ymin", "xmax", "ymax")
  )
  x
}

#' Geometry Accessor
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
