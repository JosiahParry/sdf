# sedonadb backend. A sedonadb dataframe holds nothing in R: it is a handle on
# a dataframe inside the Sedona engine. The join and filter run there.
#
# There are no predicate methods here. sedonadb has no equivalent of
# duckspatial's ddbs_predicate(): it can join on a relationship but cannot be
# asked which rows of `y` match each row of `x`, so st_within() and the rest
# say there is no applicable method rather than answering with something that
# is not the relationship.

#' @export
is_geometry.sedonadb_dataframe <- function(x) FALSE

#' The join condition sedonadb takes for a relationship
#'
#' `sd_join_intersects()` and friends build a condition over the two tables,
#' which is what `sd_join()` takes as `by`. sedonadb spells `covered_by`
#' without the underscore and has no disjoint condition at all.
#'
#' @noRd
sd_join_condition <- function(predicate, call = rlang::caller_env()) {
  name <- predicate_name(predicate, call = call)
  fn <- paste0("sd_join_", sub("covered_by", "coveredby", name))

  if (!fn %in% getNamespaceExports("sedonadb")) {
    cli::cli_abort(
      c(
        "{.pkg sedonadb} cannot join on {.val {name}}.",
        i = "It has no {.code {fn}()} condition."
      ),
      call = call
    )
  }

  getExportedValue("sedonadb", fn)
}

# Join and filter ---------------------------------------------------------

#' @export
st_join.sedonadb_dataframe <- function(
  x,
  y,
  predicate = st_intersects,
  ...,
  join_type = c("left", "inner"),
  suffix = c("_x", "_y")
) {
  join_type <- rlang::arg_match(join_type)

  sedonadb::sd_join(
    x,
    y,
    by = sd_join_condition(predicate)(...),
    join_type = join_type
  )
}

#' @export
st_filter.sedonadb_dataframe <- function(
  x,
  y,
  predicate = st_intersects,
  ...
) {
  sedonadb::sd_semi_join(x, y, by = sd_join_condition(predicate)(...))
}
