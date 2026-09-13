test_that("as_sdf() finds the geometry column and records a bbox", {
  skip_if_no_sf()
  x <- nc_sdf()

  expect_s3_class(x, "sdf")
  expect_identical(attr(x, "geom_column"), "geometry")
  expect_named(attr(x, "bbox"), c("xmin", "ymin", "xmax", "ymax"))
  expect_type(attr(x, "bbox"), "double")
})

test_that("as_sdf() errors when there is no geometry column", {
  expect_error(as_sdf(tibble::tibble(a = 1:3)), "no geometry column")
})

test_that("new_sdf() builds from columns and a geometry vector", {
  skip_if_no_sf()
  nc <- sf::st_read(system.file("shape/nc.shp", package = "sf"), quiet = TRUE)
  x <- new_sdf(list(name = as.character(nc$NAME)), sf::st_geometry(nc))

  expect_s3_class(x, "sdf")
  expect_identical(nrow(x), 100L)
})

test_that("subsetting keeps the class and the geometry", {
  skip_if_no_sf()
  x <- nc_sdf()

  expect_s3_class(x[1:3, ], "sdf")
  expect_identical(nrow(x[1:3, ]), 3L)
  expect_length(sdf_geometry(x[1:3, ]), 3L)
})

test_that("sdf_geometry() pulls the geometry column", {
  skip_if_no_sf()
  expect_s3_class(sdf_geometry(nc_sdf()), "sfc")
})
