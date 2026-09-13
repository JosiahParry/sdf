# sf backend
#
# An sfc column is a geometry column, so a tibble holding one is a spatial data
# frame. Everything below runs through sdf's generics, which dispatch to sf.

library(sf)
library(dplyr)

# sdf is attached last on purpose: it masks sf's st_ functions, and the
# package attached last is the one that wins
library(sdf)

nc <- st_read(system.file("shape/nc.shp", package = "sf"), quiet = TRUE)

counties <- as_sdf(tibble(
  name = as.character(nc$NAME),
  region = ifelse(nc$CNTY_ID > 1900, "east", "west"),
  geometry = st_geometry(nc)
))

sites <- as_sdf(tibble(
  id = 1:2,
  geometry = st_sfc(
    st_point(c(-78.6, 35.8)),
    st_point(c(-80.8, 35.2)),
    crs = st_crs(nc)
  )
))

# the contract every backend implements
is_geometry(sdf_geometry(counties))
st_extent(sdf_geometry(counties))
st_collect(sdf_geometry(counties))

# measures come back as plain numerics, as PostGIS ST_Area returns a float
head(st_area(sdf_geometry(counties)))
head(st_length(sdf_geometry(counties)))

# geometry operations
st_centroid(sdf_geometry(sites))
st_convex_hull(sdf_geometry(counties))
st_buffer(sdf_geometry(sites), 0.1)
st_union(sdf_geometry(counties))

# predicates give the row positions of `y` matching each row of `x`
st_intersects(sdf_geometry(sites), sdf_geometry(counties))

# join and filter
st_join(sites, counties, predicate = st_within)
st_filter(counties, sites)

# an inner join drops the rows of `x` that matched nothing
st_join(sites, counties, predicate = st_within, join_type = "inner")

# grouped summarise collects the geometry of each group
counties |>
  group_by(region) |>
  summarise(n = n())
