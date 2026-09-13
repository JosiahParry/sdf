#' @exportS3Method dplyr::select
select.sdf <- function(.data, ...) {
  geom_col <- which_is_geom_col(.data)
  locs <- tidyselect::eval_select(rlang::expr(c(...)), .data)

  # the geometry column is sticky, as it is in sf
  if (!(geom_col %in% locs)) locs <- sort(c(geom_col, locs))

  .data[, locs]
}

#' @exportS3Method dplyr::group_by
group_by.sdf <- function(.data, ...) {
  old_attrs <- attributes(.data)
  res <- NextMethod()

  structure(
    res,
    bbox = old_attrs[["bbox"]],
    class = c("sdf", class(res))
  )
}

#' @exportS3Method dplyr::ungroup
ungroup.sdf <- function(.data, ...) {
  res <- NextMethod()
  dplyr::dplyr_reconstruct(res, .data)
}

#' @exportS3Method dplyr::summarise
summarise.sdf <- function(.data, ...) {
  geom_col_name <- attr(.data, "geom_column")
  geom_col <- .data[[geom_col_name]]
  gd <- dplyr::group_data(.data)

  summarized_geoms <- lapply(
    gd$.rows,
    function(ids) combine_geometry(geom_col[ids])
  )

  res <- NextMethod()

  res[[geom_col_name]] <- rlang::inject(c(!!!summarized_geoms))
  as_sdf(res)
}

#' @exportS3Method dplyr::dplyr_reconstruct
dplyr_reconstruct.sdf <- function(data, template) {
  res <- NextMethod()
  as_sdf(res)
}
