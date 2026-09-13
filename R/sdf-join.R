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

#' Put one geometry vector into the type of another
#'
#' A predicate is only defined for two vectors of the same type: handing sf's
#' `st_intersects()` a `geos_geometry` fails somewhere deep in s2 rather than
#' with a useful error. wk translates between any two handleable types and
#' checks that their CRS agree, so `y` is put into the type of `x` before the
#' predicate sees it. `x` is never moved, which is what makes the type of `x`
#' the type of the result.
#'
#' @param y the geometry vector to move.
#' @param to the geometry vector whose type to move it to.
#' @returns `y`, in the type of `to`.
#' @noRd
translate_geometry <- function(y, to) {
  if (inherits(y, class(to)[1])) {
    return(y)
  }

  wk::wk_translate(y, to = to)
}

#' Spatial join and filter
#'
#' `st_join()` attaches the columns of `y` to each row of `x` that it relates
#' to spatially. `st_filter()` keeps the rows of `x` that relate to any row of
#' `y`, without adding columns.
#'
#' @details
#' Both dispatch on `x`, so a backend that holds its data somewhere other than
#' R, such as a database, can replace either and run the whole operation there.
#' The default works for any backend whose geometry vector can be subset with
#' `[` and whose predicate returns row positions.
#'
#' The default puts `y` into the geometry type of `x` before the predicate sees
#' it, so the two sides need not hold the same type.
#'
#' A row of `x` matching several rows of `y` is repeated once per match. A row
#' matching nothing is kept against `NA` when `join_type` is `"left"` and
#' dropped when it is `"inner"`. Names the two sides share are suffixed, and
#' the geometry of the result is the geometry of `x`.
#'
#' Not every backend offers both. One that cannot do a left join says so rather
#' than returning an inner join under its name.
#'
#' @param x,y spatial data frames.
#' @param predicate a function of `x` and `y` returning the row positions of
#'   `y` matching each row of `x`, such as [st_intersects()].
#' @param ... passed to `predicate`.
#' @param join_type `"left"` to keep the rows of `x` that match nothing,
#'   `"inner"` to drop them.
#' @param suffix a character vector of length 2, the suffixes for names the two
#'   sides share.
#' @returns
#' `st_join()` returns a spatial data frame of the matched rows.
#' `st_filter()` returns `x` with the unmatched rows dropped.
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
#'   st_join(sites, counties, predicate = st_within)
#'   st_filter(counties, sites)
#' }
#' @export
#' @rdname st_join
st_join <- function(
  x,
  y,
  predicate = st_intersects,
  ...,
  join_type = c("left", "inner"),
  suffix = c("_x", "_y")
) {
  UseMethod("st_join")
}

#' @export
#' @rdname st_join
st_join.default <- function(
  x,
  y,
  predicate = st_intersects,
  ...,
  join_type = c("left", "inner"),
  suffix = c("_x", "_y")
) {
  join_type <- rlang::arg_match(join_type)

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

  y_geo <- translate_geometry(sdf_geometry(y), to = x_geo)
  hits <- as_row_positions(predicate(x_geo, y_geo, ...))

  if (join_type == "inner") {
    xids <- rep(seq_along(hits), lengths(hits))
    yids <- unlist(hits, use.names = FALSE)
  } else {
    # a row that matched nothing still takes one row, against NA
    xids <- rep(seq_along(hits), pmax(lengths(hits), 1L))
    yids <- unlist(
      lapply(hits, function(hit) if (length(hit) == 0L) NA_integer_ else hit),
      use.names = FALSE
    )
  }

  out <- vctrs::vec_cbind(
    rlang::set_names(tibble::as_tibble(x)[xids, -x_geo_col], x_names),
    rlang::set_names(tibble::as_tibble(y)[yids, -y_geo_col], y_names)
  )

  out[[rlang::names2(x)[x_geo_col]]] <- x_geo[xids]
  as_sdf(out)
}

#' @export
#' @rdname st_join
st_filter <- function(x, y, predicate = st_intersects, ...) {
  UseMethod("st_filter")
}

#' @export
#' @rdname st_join
st_filter.default <- function(x, y, predicate = st_intersects, ...) {
  x_geo <- sdf_geometry(x)
  y_geo <- translate_geometry(sdf_geometry(y), to = x_geo)
  hits <- as_row_positions(predicate(x_geo, y_geo, ...))
  x[lengths(hits) > 0L, ]
}
