
#' Left join only
#' @param predicate a function that returns a sparse matrix list representation
#'
#' @export
sdf_join <- function(
    x,
    y,
    predicate = sdf_intersects,
    ...,
    suffix = c("_x", "_y")
) {

  x_geo_col <- which_is_geom_col(x)
  y_geo_col <- which_is_geom_col(y)

  x_geo <- sdf_geometry(x)
  y_geo <- sdf_geometry(y)

  x_names <- rlang::names2(x)
  y_names <- rlang::names2(y)[-y_geo_col]

  # identify common names and specify names with suffix
  common_names <- intersect(x_names, y_names)
  bad_x <- which(x_names %in% common_names)
  bad_y <- which(y_names %in% common_names)
  x_names[bad_x] <- paste0(x_names[bad_x], suffix[1])
  y_names[bad_y] <- paste0(y_names[bad_y], suffix[2])

  # get indicies for x and y
  join_indices <- predicate(x_geo, y_geo)

  ids_raw <- mapply(
    function(id, n) {
      if (n == 0) {
        yid <- NA
      } else {
        yid <- join_indices[[id]]
      }
      cbind(id, yid)
      },
    seq_along(join_indices),
    lengths(join_indices),
    SIMPLIFY = FALSE
  )

  # make into a single matrix
  ids <- do.call(rbind, ids_raw)

  xids <- ids[,1]
  yids <- ids[,2]

  x_res <- rlang::set_names(
    tibble::as_tibble(x)[xids, -x_geo_col], x_names
    )

  y_res <- rlang::set_names(
    tibble::as_tibble(y)[yids, -y_geo_col],
    y_names
    )

  as_sdf(cbind(x_res, y_res, x[xids,]))

}



#' @export
sdf_filter <- function(x, y, predicate = sdf_intersects) {
  x_geo <- sdf_geometry(x)
  y_geo <- sdf_geometry(y)
  indices <- predicate(x_geo, y_geo)
  x[which(lengths(indices) > 0),]
}
