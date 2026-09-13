#' Spatial predicates
#'
#' Each returns, for every row of `x`, the row positions of `y` that the
#' relationship holds for. Implementing them is optional, but they are what
#' [st_join()] and [st_filter()] run on.
#'
#' @details
#' A method returns a list as long as `x`, whose elements are the row positions
#' of `y`. Integer is the natural type but doubles are accepted, and an element
#' of length zero means no match. An sf `sgbp` already has this shape.
#'
#' @param x,y geometry vectors.
#' @param ... passed to the method.
#' @returns A list as long as `x`, each element the row positions of `y` that
#'   match.
#' @examples
#' if (requireNamespace("sf", quietly = TRUE)) {
#'   nc <- sf::st_read(system.file("shape/nc.shp", package = "sf"), quiet = TRUE)
#'   geometry <- sf::st_geometry(nc)
#'
#'   st_intersects(geometry[1:3], geometry[1:10])
#' }
#' @export
#' @rdname predicates
st_intersects <- function(x, y, ...) UseMethod("st_intersects")

#' @export
#' @rdname predicates
st_contains <- function(x, y, ...) UseMethod("st_contains")

#' @export
#' @rdname predicates
st_within <- function(x, y, ...) UseMethod("st_within")

#' @export
#' @rdname predicates
st_crosses <- function(x, y, ...) UseMethod("st_crosses")

#' @export
#' @rdname predicates
st_covers <- function(x, y, ...) UseMethod("st_covers")

#' @export
#' @rdname predicates
st_covered_by <- function(x, y, ...) UseMethod("st_covered_by")

#' @export
#' @rdname predicates
st_equals <- function(x, y, ...) UseMethod("st_equals")

#' @export
#' @rdname predicates
st_disjoint <- function(x, y, ...) UseMethod("st_disjoint")

#' @export
#' @rdname predicates
st_touches <- function(x, y, ...) UseMethod("st_touches")

#' @export
#' @rdname predicates
st_overlaps <- function(x, y, ...) UseMethod("st_overlaps")

#' @param distance the distance within which the relationship holds.
#' @export
#' @rdname predicates
st_dwithin <- function(x, y, distance, ...) UseMethod("st_dwithin")

#' Which relationship a predicate tests
#'
#' A backend that runs the join in a database cannot call an R function inside
#' its query, so it needs the name of the relationship rather than the
#' predicate itself. The predicates are recognised by identity, which keeps the
#' answer out of the user facing argument: `predicate` stays a function.
#'
#' @param predicate one of the predicates.
#' @returns The relationship as a string, such as `"intersects"`.
#' @noRd
predicate_name <- function(predicate, call = rlang::caller_env()) {
  known <- c(
    "intersects",
    "contains",
    "within",
    "crosses",
    "covers",
    "covered_by",
    "equals",
    "disjoint",
    "touches",
    "overlaps",
    "dwithin"
  )

  ns <- asNamespace("sdf")

  for (name in known) {
    if (identical(predicate, get(paste0("st_", name), envir = ns))) {
      return(name)
    }
  }

  cli::cli_abort(
    c(
      "{.arg predicate} must be one of {.or {.fn {paste0('st_', known)}}}.",
      i = "This backend runs the join outside R, where a function of your own
           cannot be called."
    ),
    call = call
  )
}

