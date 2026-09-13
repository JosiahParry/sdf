#' Row positions from a predicate, whatever the backend returned
#'
#' The predicate contract is the row positions of `y` that match each row of
#' `x`. Backends produce that in different shapes: an `sgbp` from sf, a list of
#' doubles from an Arrow backed vector, a list of integers. Any of them is
#' accepted and normalised here rather than demanded of the backend.
#'
#' @param x a predicate result.
#' @returns a list of integer vectors, empty where nothing matched.
#' @noRd
as_row_positions <- function(x) {
  if (!is.list(x)) {
    x <- as.list(x)
  }

  lapply(x, function(hit) {
    if (is.null(hit) || length(hit) == 0L) integer() else as.integer(hit)
  })
}

#' Spatial join and filter
#'
#' `sdf_join()` attaches the columns of `y` to each row of `x` that it relates
#' to spatially. `sdf_filter()` keeps the rows of `x` that relate to any row of
#' `y`, without adding columns.
#'
#' @details
#' Both dispatch on the geometry column of `x`, so a backend can replace either
#' with an implementation in its own types. The default works for any backend
#' whose geometry vector can be subset with `[` and whose predicate returns row
#' positions.
#'
#' A row of `x` matching several rows of `y` is repeated once per match, and a
#' row matching nothing is kept against `NA`, so `sdf_join()` is a left join.
#' Names the two sides share are suffixed, and the geometry of the result is
#' the geometry of `x`.
#'
#' @param x,y spatial data frames.
#' @param predicate a function of `x` and `y` returning the row positions of
#'   `y` matching each row of `x`, such as [sdf_intersects()].
#' @param ... passed to `predicate`.
#' @param suffix a character vector of length 2, the suffixes for names the two
#'   sides share.
#' @returns
#' `sdf_join()` returns a spatial data frame of the matched rows.
#' `sdf_filter()` returns `x` with the unmatched rows dropped.
#' @examples
#' if (requireNamespace("sf", quietly = TRUE)) {
#'   nc <- sf::st_read(system.file("shape/nc.shp", package = "sf"), quiet = TRUE)
#'
#'   counties <- as_sdf(tibble::tibble(
#'     name = as.character(nc$NAME),
#'     geometry = sf::st_geometry(nc)
#'   ))
#'
#'   sites <- as_sdf(tibble::tibble(
#'     id = 1:2,
#'     geometry = sf::st_sfc(
#'       sf::st_point(c(-78.6, 35.8)),
#'       sf::st_point(c(-80.8, 35.2)),
#'       crs = sf::st_crs(nc)
#'     )
#'   ))
#'
#'   sdf_join(sites, counties, predicate = sdf_within)
#'   sdf_filter(counties, sites)
#' }
#' @export
#' @rdname sdf_join
sdf_join <- function(
  x,
  y,
  predicate = sdf_intersects,
  ...,
  suffix = c("_x", "_y")
) {
  UseMethod("sdf_join", sdf_geometry(x))
}

#' @export
#' @rdname sdf_join
sdf_join.default <- function(
  x,
  y,
  predicate = sdf_intersects,
  ...,
  suffix = c("_x", "_y")
) {
  if (!is.character(suffix) || length(suffix) != 2L) {
    rlang::abort("`suffix` must be a character vector of length 2.")
  }

  x_geo_col <- which_is_geom_col(x)[[1]]
  y_geo_col <- which_is_geom_col(y)[[1]]
  x_geo <- sdf_geometry(x)

  # the geometry column comes off both sides before the names are taken: it is
  # not carried through from `y`, and it comes back from `x` at the end
  x_names <- rlang::names2(x)[-x_geo_col]
  y_names <- rlang::names2(y)[-y_geo_col]

  shared <- intersect(x_names, y_names)
  x_names[x_names %in% shared] <- paste0(x_names[x_names %in% shared], suffix[1])
  y_names[y_names %in% shared] <- paste0(y_names[y_names %in% shared], suffix[2])

  hits <- as_row_positions(predicate(x_geo, sdf_geometry(y), ...))

  # a row that matched nothing still takes one row, against NA
  xids <- rep(seq_along(hits), pmax(lengths(hits), 1L))
  yids <- unlist(
    lapply(hits, function(hit) if (length(hit) == 0L) NA_integer_ else hit),
    use.names = FALSE
  )

  out <- vctrs::vec_cbind(
    rlang::set_names(tibble::as_tibble(x)[xids, -x_geo_col], x_names),
    rlang::set_names(tibble::as_tibble(y)[yids, -y_geo_col], y_names)
  )

  out[[rlang::names2(x)[x_geo_col]]] <- x_geo[xids]
  as_sdf(out)
}

#' @export
#' @rdname sdf_join
sdf_filter <- function(x, y, predicate = sdf_intersects, ...) {
  UseMethod("sdf_filter", sdf_geometry(x))
}

#' @export
#' @rdname sdf_join
sdf_filter.default <- function(x, y, predicate = sdf_intersects, ...) {
  hits <- as_row_positions(predicate(sdf_geometry(x), sdf_geometry(y), ...))
  x[lengths(hits) > 0L, ]
}
