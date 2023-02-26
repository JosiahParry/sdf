#' @export
is_geometry <- function(x) UseMethod("is_geometry")

#' @export
is_geometry.default <- function(x) {
  inherits(
    x,
    c("sfc",
      "rs_POINT", "rs_MULTIPOINT",
      "rs_POLYGON", "rs_MULTIPOLYGON",
      "rs_LINESTRING", "rs_MULTILINESTRING")
  )
}

#' @export
bounding_box <- function(x) UseMethod("bounding_box")
bounding_box.sfc <- function(x) sf::st_bbox(x)

validate_bbox <- function(x) {
  stopifnot(
    is.numeric(x),
    length(x) == 4,
    names(x) == c("xmin", "ymin", "xmax", "ymax")
  )
  x
}

#' @export
combine_geometry <- function(x) UseMethod("combine_geometry")

#' @export
combine_geometry.sfc <- function(x) sf::st_combine(x)

#' @export
combine_geometry.rs_MULTIPOLYGON <- function(x) rsgeo::combine_geoms(x)

#' @export
union_geometry <- function(x) UseMethod("union_geometry")

#' @export
union_geometry.sfc <- function(x) sf::st_union(x)

# helper to find geom column
which_is_geom_col <- function(x) which(vapply(x, is_geometry, logical(1)))

#' @export
as_sdf <- function(x) {
  geom_col <- which_is_geom_col(x)

  tibble::new_tibble(
    x,
    class = "sdf",
    geom_column = names(geom_col)[1],
    bbox = validate_bbox(bounding_box(x[[geom_col]]))
  )
}

#' @export
new_sdf <- function(x, geometry) {
  tibble::new_tibble(
    vctrs::df_list(!!!x, geometry = geometry),
    class = "sdf",
    geom_column = "geometry",
    bbox = validate_bbox(bounding_box(geometry))
  )
}


#' @importFrom dplyr dplyr_reconstruct
#' @export
dplyr_reconstruct.sdf <- function(data, template) {
  res <- NextMethod()
  as_sdf(res)
}


#' @export
`[.sdf` <- function(x, i, j, ...) {

  if (missing(i) && missing(j)) return(x)

  # extract points column
  geom_col_name <- attr(x, "geom_column")
  geom_col <- x[[geom_col_name]]


  res <- NextMethod()

  # x[i,]
  if (!missing(i) && missing(j)) {
    res[[geom_col_name]] <- geom_col[i]
    return(res)
  }

  # # x[i]
  # if (missing(j)) {
  #   res[[geom_col_name]] <- geom_col
  #   return(res)
  # }

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
