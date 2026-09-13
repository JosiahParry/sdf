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

# is_geometry.default lives in generics.R. A second copy here used to shadow it
# through collation order, so the documented wk default never applied and any
# type not on its hardcoded list was invisible to as_sdf().
