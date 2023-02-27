# helper to find geom column
# named vector with position of geometry column
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



