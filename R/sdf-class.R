# helper to find geom column
# named vector with position of geometry column
which_is_geom_col <- function(x) which(vapply(x, is_geometry, logical(1)))

#' Create a spatial data frame
#'
#' `as_sdf()` promotes a data frame that already holds a geometry column.
#' `new_sdf()` builds one from a data frame and a geometry vector.
#'
#' @details
#' The geometry column is found with [is_geometry()], so any vector whose class
#' implements the sdf generics can be the geometry. The bounding box is computed
#' once with [st_extent()] and carried as an attribute.
#'
#' @param x for `as_sdf()`, a data frame holding a geometry column. For
#'   `new_sdf()`, a data frame or named list of the other columns.
#' @param geometry a geometry vector, as long as `x` has rows.
#' @returns A spatial data frame, a tibble of class `sdf`.
#' @examples
#' if (requireNamespace("sf", quietly = TRUE)) {
#'   nc <- sf::st_read(system.file("shape/nc.shp", package = "sf"), quiet = TRUE)
#'
#'   as_sdf(tibble::tibble(
#'     name = as.character(nc$NAME),
#'     geometry = sf::st_geometry(nc)
#'   ))
#'
#'   new_sdf(list(name = as.character(nc$NAME)), sf::st_geometry(nc))
#' }
#' @export
#' @rdname sdf
as_sdf <- function(x) {
  geom_col <- which_is_geom_col(x)

  if (length(geom_col) == 0L) {
    rlang::abort("`x` has no geometry column.")
  }

  tibble::new_tibble(
    x,
    class = "sdf",
    geom_column = names(geom_col)[1],
    bbox = validate_bbox(st_extent(x[[geom_col[[1]]]]))
  )
}

#' @export
#' @rdname sdf
new_sdf <- function(x, geometry) {
  tibble::new_tibble(
    vctrs::df_list(!!!x, geometry = geometry),
    class = "sdf",
    geom_column = "geometry",
    bbox = validate_bbox(st_extent(geometry))
  )
}


#' Subset a spatial data frame
#'
#' Keeps the geometry column and the `sdf` class through a `[` subset, which
#' the tibble method alone would drop.
#'
#' @param x a spatial data frame.
#' @param i,j rows and columns to keep.
#' @param ... passed on to the tibble method.
#' @returns A spatial data frame.
#' @examples
#' if (requireNamespace("sf", quietly = TRUE)) {
#'   nc <- sf::st_read(system.file("shape/nc.shp", package = "sf"), quiet = TRUE)
#'
#'   x <- as_sdf(tibble::tibble(
#'     name = as.character(nc$NAME),
#'     geometry = sf::st_geometry(nc)
#'   ))
#'
#'   x[1:3, ]
#' }
#' @export
`[.sdf` <- function(x, i, j, ...) {

  if (missing(i) && missing(j)) return(x)

  # extract points column
  geom_col_name <- attr(x, "geom_column")
  geom_col <- x[[geom_col_name]]


  res <- NextMethod()

  # x[i,]
  if (!missing(i) && missing(j) && nargs() > 1) {
    res[[geom_col_name]] <- geom_col[i]
    return(res)
  }

  # # x[i]
  if (missing(j)) {
    res[[geom_col_name]] <- geom_col
    return(res)
  }

  # x[i, j]
  if (!missing(i) && !missing(j)) {
    geom_col <- geom_col[i]
    res[[geom_col_name]] <- geom_col
    return(res)
  }

  #x[, j]
  if (missing(i) && !missing(j)) {
    res[[geom_col_name]] <- geom_col
    return(res)
  }

  res
}



