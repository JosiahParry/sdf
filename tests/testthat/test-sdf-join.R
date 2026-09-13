test_that("as_row_positions() accepts whatever a backend returns", {
  # integers, doubles, an sgbp shaped list, and empties all normalise
  expect_identical(
    as_row_positions(list(1:2, c(3, 4), integer(), NULL)),
    list(1:2, 3:4, integer(), integer())
  )
})

test_that("st_join() attaches the matching rows", {
  skip_if_no_sf()
  joined <- st_join(site_sdf(), nc_sdf(), predicate = st_within)

  expect_s3_class(joined, "sdf")
  expect_identical(nrow(joined), 2L)
  expect_setequal(joined$name, c("Wake", "Mecklenburg"))
})

test_that("st_join() keeps the geometry of x, under its own name", {
  skip_if_no_sf()
  joined <- st_join(site_sdf(), nc_sdf(), predicate = st_within)

  expect_identical(attr(joined, "geom_column"), "geometry")
  expect_length(sdf_geometry(joined), 2L)
})

test_that("st_join() is a left join", {
  skip_if_no_sf()
  far <- as_sdf(tibble::tibble(
    id = 99L,
    geometry = sf::st_sfc(sf::st_point(c(0, 0)), crs = 4267)
  ))

  joined <- st_join(far, nc_sdf(), predicate = st_within)
  expect_identical(nrow(joined), 1L)
  expect_true(is.na(joined$name))
})

test_that("st_join() suffixes shared names and does not duplicate columns", {
  skip_if_no_sf()
  sites <- as_sdf(tibble::tibble(
    name = c("a", "b"),
    geometry = sdf_geometry(site_sdf())
  ))

  joined <- st_join(sites, nc_sdf(), predicate = st_within)

  expect_true(all(c("name_x", "name_y") %in% names(joined)))
  expect_false(anyDuplicated(names(joined)) > 0L)
})

test_that("st_join() does not require integer row positions", {
  skip_if_no_sf()
  as_double <- function(x, y, ...) lapply(st_within(x, y), as.double)

  joined <- st_join(site_sdf(), nc_sdf(), predicate = as_double)
  expect_setequal(joined$name, c("Wake", "Mecklenburg"))
})

test_that("st_filter() keeps only the rows that relate", {
  skip_if_no_sf()
  kept <- st_filter(nc_sdf(), site_sdf())

  expect_s3_class(kept, "sdf")
  expect_identical(nrow(kept), 2L)
  expect_setequal(kept$name, c("Wake", "Mecklenburg"))
})

test_that("st_join() and st_filter() dispatch on the geometry", {
  # a backend can replace either with its own implementation
  expect_true(is.function(st_join.default))
  expect_true(is.function(st_filter.default))
})
