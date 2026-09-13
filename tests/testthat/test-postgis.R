poly_sfc <- function() {
  nc <- sf::st_read(system.file("shape/nc.shp", package = "sf"), quiet = TRUE)
  sf::st_geometry(nc)[1:3]
}

test_that("the overlay operations pair the two vectors", {
  skip_if_no_sf()

  a <- poly_sfc()
  b <- sf::st_buffer(a, 0.05)

  expect_s3_class(st_intersection(a, b), "sfc")
  expect_s3_class(st_difference(b, a), "sfc")
  expect_s3_class(st_sym_difference(a, b), "sfc")
})

test_that("measurement returns plain numerics, as PostGIS returns floats", {
  skip_if_no_sf()

  a <- poly_sfc()

  expect_type(st_area(a), "double")
  expect_type(st_perimeter(a), "double")

  # ST_Distance pairs the two vectors rather than building a matrix
  expect_length(st_distance(a, poly_sfc()), 3L)
  expect_type(st_distance(a, poly_sfc()), "double")
})

test_that("the per geometry tests answer once per geometry", {
  skip_if_no_sf()

  a <- poly_sfc()

  expect_identical(st_is_valid(a), rep(TRUE, 3L))
  expect_identical(st_is_empty(a), rep(FALSE, 3L))
  expect_length(st_is_simple(a), 3L)
  expect_identical(st_geometry_type(a), rep("MULTIPOLYGON", 3L))
})

test_that("the processing operations return one geometry per geometry", {
  skip_if_no_sf()

  a <- poly_sfc()

  expect_length(st_make_valid(a), 3L)
  expect_length(st_reverse(a), 3L)
  expect_length(suppressWarnings(st_point_on_surface(a)), 3L)
  expect_length(st_boundary(a), 3L)
  expect_identical(suppressWarnings(st_relate(a, a)), rep("2FFF1FFF2", 3L))
})

test_that("st_dwithin() is a predicate st_join() can run on", {
  skip_if_no_sf()

  counties <- nc_sdf()
  sites <- site_sdf()

  kept <- st_filter(counties, sites, predicate = st_dwithin, distance = 0.2)
  expect_s3_class(kept, "sdf")
  expect_true(nrow(kept) >= 2L)
})

test_that("geos answers for the operations it has", {
  skip_if_no_sf()
  skip_if_not_installed("geos")

  a <- geos::as_geos_geometry(poly_sfc())

  expect_identical(st_is_valid(a), rep(TRUE, 3L))
  expect_identical(st_geometry_type(a), rep("multipolygon", 3L))
  expect_length(st_envelope(a), 3L)
  expect_length(st_num_geometries(a), 3L)
  expect_type(st_distance(a, a), "double")

  # geos has no matrix form of within distance, so there is no method
  expect_error(st_dwithin(a, a, 0.1), "applicable method")
})

test_that("s2 answers for the operations it has", {
  skip_if_no_sf()
  skip_if_not_installed("s2")

  a <- s2::as_s2_geography(poly_sfc())

  expect_identical(st_is_valid(a), rep(TRUE, 3L))
  expect_type(st_perimeter(a), "double")
  expect_length(st_num_points(a), 3L)
  expect_length(st_dwithin(a, a, 100), 3L)

  # s2 has no simplicity test or geometry type
  expect_error(st_is_simple(a), "applicable method")
})

test_that("masking leaves sf's own classes working", {
  skip_if_no_sf()

  nc <- sf::st_read(system.file("shape/nc.shp", package = "sf"), quiet = TRUE)

  # these reach sf through the delegates registered on load
  expect_s3_class(suppressWarnings(st_centroid(nc[1:3, ])), "sf")
  expect_s3_class(st_boundary(nc[1:3, ]), "sf")
  expect_length(st_area(nc[1:3, ]), 3L)
  expect_s3_class(st_join(nc[1:3, ], nc), "sf")
})
