# The three bundled backends must be reachable for a user calling the generic
# directly, not only from inside this namespace.

test_that("the sf backend is registered and dispatches", {
  skip_if_no_sf()
  geometry <- sdf_geometry(nc_sdf())

  expect_true(is_geometry(geometry))
  expect_named(bounding_box(geometry), c("xmin", "ymin", "xmax", "ymax"))
  expect_length(combine_geometry(geometry), 1L)
  expect_s3_class(sdf_intersects(geometry[1:3], geometry[1:5]), "sgbp")
  expect_s3_class(simplify_geometry(geometry[1:3], 0.05), "sfc")
})

test_that("the geos backend is registered and dispatches", {
  skip_if_not_installed("geos")
  skip_if_no_sf()
  geometry <- geos::as_geos_geometry(sdf_geometry(nc_sdf()))

  expect_true(is_geometry(geometry))
  expect_named(bounding_box(geometry), c("xmin", "ymin", "xmax", "ymax"))
  expect_length(combine_geometry(geometry), 1L)
  expect_type(sdf_intersects(geometry[1:3], geometry[1:5]), "list")
})

test_that("the s2 backend is registered and dispatches", {
  skip_if_not_installed("s2")
  skip_if_no_sf()
  geometry <- s2::as_s2_geography(sdf_geometry(nc_sdf()))

  expect_true(is_geometry(geometry))
  expect_named(bounding_box(geometry), c("xmin", "ymin", "xmax", "ymax"))
  expect_type(sdf_intersects(geometry[1:3], geometry[1:5]), "list")
})

test_that("the predicates point the same way in every backend", {
  skip_if_no_sf()
  skip_if_not_installed("geos")

  counties <- sdf_geometry(nc_sdf())
  sites <- sdf_geometry(site_sdf())

  from_sf <- unlist(sdf_within(sites, counties))
  from_geos <- unlist(sdf_within(
    geos::as_geos_geometry(sites),
    geos::as_geos_geometry(counties)
  ))

  # the row positions agree; the storage type is the backend's business, which
  # is why as_row_positions() normalises rather than demanding integer
  expect_equal(from_sf, from_geos, ignore_attr = TRUE)
})

test_that("a join gives the same answer in every backend", {
  skip_if_no_sf()
  skip_if_not_installed("geos")

  counties <- nc_sdf()
  sites <- site_sdf()

  as_geos <- function(x) {
    x[["geometry"]] <- geos::as_geos_geometry(x[["geometry"]])
    as_sdf(x)
  }

  expect_setequal(
    sdf_join(sites, counties, predicate = sdf_within)$name,
    sdf_join(as_geos(sites), as_geos(counties), predicate = sdf_within)$name
  )
})
