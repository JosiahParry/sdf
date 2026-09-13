nc_sf <- function() {
  nc <- sf::st_read(system.file("shape/nc.shp", package = "sf"), quiet = TRUE)
  nc[, c("NAME", "geometry")]
}

sites_sf <- function() {
  sf::st_sf(
    id = 1:2,
    geometry = sf::st_sfc(
      sf::st_point(c(-78.6, 35.8)),
      sf::st_point(c(-80.8, 35.2)),
      crs = 4267
    )
  )
}

test_that("duckspatial runs the join and the filter in duckdb", {
  skip_if_not_installed("sf")
  skip_if_not_installed("duckspatial")

  counties <- duckspatial::as_duckspatial_df(nc_sf())
  sites <- duckspatial::as_duckspatial_df(sites_sf())

  kept <- st_filter(counties, sites)
  expect_s3_class(kept, "duckspatial_df")
  expect_setequal(
    duckspatial::ddbs_collect(kept, as = "tibble")$NAME,
    c("Wake", "Mecklenburg")
  )

  joined <- st_join(counties, sites, join_type = "inner")
  expect_s3_class(joined, "duckspatial_df")
  expect_setequal(
    duckspatial::ddbs_collect(joined, as = "tibble")$NAME,
    c("Wake", "Mecklenburg")
  )
})

test_that("duckspatial says so rather than passing off an inner join", {
  skip_if_not_installed("sf")
  skip_if_not_installed("duckspatial")

  counties <- duckspatial::as_duckspatial_df(nc_sf())
  sites <- duckspatial::as_duckspatial_df(sites_sf())

  expect_error(st_join(counties, sites), "inner join")
})

test_that("sedonadb runs the join and the filter in the engine", {
  skip_if_not_installed("sf")
  skip_if_not_installed("sedonadb")

  counties <- sedonadb::as_sedonadb_dataframe(nc_sf())
  sites <- sedonadb::as_sedonadb_dataframe(sites_sf())

  kept <- st_filter(counties, sites)
  expect_s3_class(kept, "sedonadb_dataframe")
  expect_setequal(
    sedonadb::sd_collect(kept)$NAME,
    c("Wake", "Mecklenburg")
  )

  joined <- st_join(counties, sites, join_type = "inner")
  expect_s3_class(joined, "sedonadb_dataframe")
  expect_setequal(
    sedonadb::sd_collect(joined)$NAME,
    c("Wake", "Mecklenburg")
  )
})

test_that("a duckspatial predicate answers with the matching rows", {
  skip_if_not_installed("sf")
  skip_if_not_installed("duckspatial")

  counties <- duckspatial::as_duckspatial_df(nc_sf())
  sites <- duckspatial::as_duckspatial_df(sites_sf())

  hits <- dplyr::collect(st_within(sites, counties))

  expect_named(hits, c("id_x", "id_y"))
  expect_identical(nrow(hits), 2L)
  expect_setequal(hits$id_x, c(1, 2))

  # the same answer duckspatial gives for itself
  expect_equal(
    hits,
    dplyr::collect(
      duckspatial::ddbs_within(sites, counties)
    )
  )
})

test_that("sedonadb says so rather than answering with a join condition", {
  skip_if_not_installed("sf")
  skip_if_not_installed("sedonadb")

  s <- sedonadb::as_sedonadb_dataframe(nc_sf())

  # it can join on a relationship but cannot say which rows matched
  expect_error(st_within(s, s), "applicable method")
})

test_that("neither engine frame holds a geometry column", {
  skip_if_not_installed("sf")
  skip_if_not_installed("duckspatial")
  skip_if_not_installed("sedonadb")

  expect_false(is_geometry(duckspatial::as_duckspatial_df(nc_sf())))
  expect_false(is_geometry(sedonadb::as_sedonadb_dataframe(nc_sf())))
})
