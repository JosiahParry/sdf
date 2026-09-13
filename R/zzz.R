# Names sdf takes over from sf. Attaching sdf after sf shadows them, so every
# class sf used to answer for has to keep working: each is registered back onto
# our generic, delegating to sf's own implementation. Without this, masking
# st_centroid() would break st_centroid() on an sf data frame for anyone who
# loaded sdf.
sf_masked <- c(
  "st_join",
  "st_filter",
  "st_intersects",
  "st_contains",
  "st_within",
  "st_crosses",
  "st_covers",
  "st_covered_by",
  "st_equals",
  "st_disjoint",
  "st_touches",
  "st_overlaps",
  "st_union",
  "st_simplify",
  "st_buffer",
  "st_centroid",
  "st_convex_hull",
  "st_concave_hull",
  "st_area",
  "st_length",
  "st_intersection",
  "st_difference",
  "st_sym_difference",
  "st_distance",
  "st_perimeter",
  "st_is_valid",
  "st_is_empty",
  "st_is_simple",
  "st_geometry_type",
  "st_boundary",
  "st_make_valid",
  "st_reverse",
  "st_point_on_surface",
  "st_relate"
)

# classes sdf answers for itself, so sf's implementation must not be put back
sdf_owned <- c("sfc", "geos_geometry", "s2_geography")

is_sf_generic <- function(generic) {
  fn <- getExportedValue("sf", generic)
  any(grepl("UseMethod", deparse(body(fn)), fixed = TRUE))
}

# a generic of sf's cannot be called by name from here: its dispatch searches
# the environment it was called from, lands back on our own method and recurses.
# Its registered method is reached directly instead. A plain function of sf's
# has no such problem.
sf_delegate <- function(generic, class) {
  force(generic)
  force(class)

  if (is_sf_generic(generic)) {
    function(...) {
      utils::getS3method(generic, class, envir = asNamespace("sf"))(...)
    }
  } else {
    function(...) getExportedValue("sf", generic)(...)
  }
}

sf_classes <- function(generic) {
  if (!is_sf_generic(generic)) {
    # sf answers for these without dispatching, so there is no method table to
    # read and the classes have to be named
    return(c("sf", "sfg"))
  }

  table <- get(".__S3MethodsTable__.", envir = asNamespace("sf"))
  prefix <- paste0(generic, ".")
  keys <- ls(table)
  substring(keys[startsWith(keys, prefix)], nchar(prefix) + 1L)
}

register_sf_delegates <- function() {
  for (generic in sf_masked) {
    for (class in setdiff(sf_classes(generic), sdf_owned)) {
      registerS3method(
        generic,
        class,
        sf_delegate(generic, class),
        envir = asNamespace("sdf")
      )
    }
  }
}

# Whichever of sdf and sf is attached last wins the name, and a user writing
# library(sdf) before library(sf) would otherwise find that st_centroid() on a
# geos_geometry has no method, because sf's generic never sees ours. Our
# methods go onto sf's generics as well, so attach order stops mattering.
#
# Only works where sf's function is a generic. sf answers for the rest without
# dispatching, so nothing can be registered on them and those names do depend
# on attach order.
register_methods_on_sf <- function() {
  ours <- get(".__S3MethodsTable__.", envir = asNamespace("sdf"))
  keys <- ls(ours)

  for (generic in sf_masked) {
    if (!is_sf_generic(generic)) {
      next
    }

    prefix <- paste0(generic, ".")
    theirs <- sf_classes(generic)

    for (key in keys[startsWith(keys, prefix)]) {
      class <- substring(key, nchar(prefix) + 1L)

      # sf already answers for its own classes
      if (class %in% theirs) {
        next
      }

      registerS3method(
        generic,
        class,
        get(key, envir = ours),
        envir = asNamespace("sf")
      )
    }
  }
}

.onLoad <- function(...) {
  vctrs::s3_register("dplyr::select", "sdf")
  vctrs::s3_register("dplyr::group_by", "sdf")
  vctrs::s3_register("dplyr::ungroup", "sdf")
  vctrs::s3_register("dplyr::summarise", "sdf")
  vctrs::s3_register("dplyr::dplyr_reconstruct", "sdf")

  # ours go on first, while our method table holds only our own methods and not
  # the delegates registered next
  wire_up_sf <- function(...) {
    register_methods_on_sf()
    register_sf_delegates()
  }

  # sf is suggested, so wait for it rather than pulling it in
  if (isNamespaceLoaded("sf")) {
    wire_up_sf()
  }

  setHook(packageEvent("sf", "onLoad"), wire_up_sf)
}
