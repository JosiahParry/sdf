#' @export
select.sdf <- function(.data, ...) {
  geom_col <- which_is_geom_col(.data)
  locs <- tidyselect::eval_select(rlang::expr(c(...)), .data)

  if (!(geom_col %in% locs)) locs <- sort(c(geom_col, locs))

  .data[,locs]
}

# select(x, crime_pers, geometry)

#' @export
group_by.sdf <- function(.data, ...) {
  old_attrs <- attributes(.data)
  res <- NextMethod()
  structure(
    res,
    bbox = old_attrs[["bbox"]],
    class = c("sdf", class(res))
  )
}

#' @export
ungroup.sdf <- function(.data, ...) {
  res <- NextMethod()
  dplyr_reconstruct(res, .data)
}

#' @export
summarise.sdf <- function(.data, ...) {
  geom_col_name <- attr(.data, "geom_column")
  geom_col <- .data[[geom_col_name]]
  gd <- group_data(.data)

  summarized_geoms <- lapply(gd$.rows, function(ids) combine_geometry(geom_col[ids]))

  res <- NextMethod()

  res[[geom_col_name]] <- rlang::inject(c(!!!summarized_geoms))
  as_sdf(res)

}
#
# x |>
#   group_by(region) |>
#   summarise(total_crime = sum(crime_pers))
#
# x |>
#   mutate(geometry = rsgeo::as_rsgeom(geometry)) |>
#   group_by(region) |>
#   summarise(total_crime = sum(crime_pers))
#
#
#
#
