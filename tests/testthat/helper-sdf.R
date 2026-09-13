skip_if_no_sf <- function() skip_if_not_installed("sf")

nc_sdf <- function() {
  nc <- sf::st_read(system.file("shape/nc.shp", package = "sf"), quiet = TRUE)
  as_sdf(tibble::tibble(
    name = as.character(nc$NAME),
    births = as.numeric(nc$BIR74),
    geometry = sf::st_geometry(nc)
  ))
}

site_sdf <- function() {
  as_sdf(tibble::tibble(
    id = 1:2,
    geometry = sf::st_sfc(
      sf::st_point(c(-78.6, 35.8)),
      sf::st_point(c(-80.8, 35.2)),
      crs = 4267
    )
  ))
}
