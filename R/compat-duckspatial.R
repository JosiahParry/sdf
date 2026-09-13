# duckspatial backend. A duckspatial_df is a lazy dbplyr table over DuckDB, so
# there is no geometry column to hand a predicate and no rows to subset in R.
# Everything below stays a query: a predicate answers with the matching row
# pairs as another lazy table, and the join and filter run in the database.

#' @export
is_geometry.duckspatial_df <- function(x) FALSE

# Predicates --------------------------------------------------------------
# ddbs_predicate() answers with a lazy table of id_x and id_y, the rows of `y`
# that match each row of `x`, which is the relationship itself rather than a
# token standing in for it

#' @export
st_intersects.duckspatial_df <- function(x, y, ...) {
  duckspatial::ddbs_predicate(x, y, "intersects", ...)
}

#' @export
st_contains.duckspatial_df <- function(x, y, ...) {
  duckspatial::ddbs_predicate(x, y, "contains", ...)
}

#' @export
st_within.duckspatial_df <- function(x, y, ...) {
  duckspatial::ddbs_predicate(x, y, "within", ...)
}

#' @export
st_crosses.duckspatial_df <- function(x, y, ...) {
  duckspatial::ddbs_predicate(x, y, "crosses", ...)
}

#' @export
st_covers.duckspatial_df <- function(x, y, ...) {
  duckspatial::ddbs_predicate(x, y, "covers", ...)
}

#' @export
st_covered_by.duckspatial_df <- function(x, y, ...) {
  duckspatial::ddbs_predicate(x, y, "covered_by", ...)
}

#' @export
st_equals.duckspatial_df <- function(x, y, ...) {
  duckspatial::ddbs_predicate(x, y, "equals", ...)
}

#' @export
st_disjoint.duckspatial_df <- function(x, y, ...) {
  duckspatial::ddbs_predicate(x, y, "disjoint", ...)
}

#' @export
st_touches.duckspatial_df <- function(x, y, ...) {
  duckspatial::ddbs_predicate(x, y, "touches", ...)
}

#' @export
st_overlaps.duckspatial_df <- function(x, y, ...) {
  duckspatial::ddbs_predicate(x, y, "overlaps", ...)
}

#' @export
st_dwithin.duckspatial_df <- function(x, y, distance, ...) {
  duckspatial::ddbs_predicate(x, y, "dwithin", distance = distance, ...)
}

# Join and filter ---------------------------------------------------------
# these do not run the predicate: duckdb does the whole join in one query, so
# what it needs is the name of the relationship, not an answer about rows

#' @export
st_join.duckspatial_df <- function(
  x,
  y,
  predicate = st_intersects,
  ...,
  join_type = c("left", "inner"),
  suffix = c("_x", "_y")
) {
  join_type <- rlang::arg_match(join_type)

  if (join_type != "inner") {
    cli::cli_abort(c(
      "{.pkg duckspatial} can only do an inner join.",
      i = "{.fn duckspatial::ddbs_join} builds a plain {.code JOIN}, so rows of
           {.arg x} matching nothing are dropped.",
      i = "Pass {.code join_type = \"inner\"} to ask for that."
    ))
  }

  duckspatial::ddbs_join(x, y, join = predicate_name(predicate), ...)
}

#' @export
st_filter.duckspatial_df <- function(x, y, predicate = st_intersects, ...) {
  duckspatial::ddbs_filter(x, y, predicate = predicate_name(predicate), ...)
}
