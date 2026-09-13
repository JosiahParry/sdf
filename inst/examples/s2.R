# s2 backend
#
# An s2_geography column is a geometry column. s2 works on the sphere, so
# measures and predicates are spherical rather than planar.

library(sf)
library(s2)
library(dplyr)

# sdf is attached last on purpose: it masks sf's st_ functions, and the
# package attached last is the one that wins
library(sdf)

nc <- st_read(system.file("shape/nc.shp", package = "sf"), quiet = TRUE)

counties <- as_sdf(tibble(
  name = as.character(nc$NAME),
  region = ifelse(nc$CNTY_ID > 1900, "east", "west"),
  geometry = as_s2_geography(st_geometry(nc))
))

sites <- as_sdf(tibble(
  id = 1:2,
  geometry = as_s2_geography(st_sfc(
    st_point(c(-78.6, 35.8)),
    st_point(c(-80.8, 35.2)),
    crs = st_crs(nc)
  ))
))

is_geometry(sdf_geometry(counties))

# s2_bounds_rect() gives a one row data frame, so s2 has its own st_extent()
st_extent(sdf_geometry(counties))

st_collect(sdf_geometry(counties))

st_centroid(sdf_geometry(sites))
st_convex_hull(sdf_geometry(counties))
st_buffer(sdf_geometry(sites), 1000)
st_union(sdf_geometry(counties))

st_intersects(sdf_geometry(sites), sdf_geometry(counties))

st_join(sites, counties, predicate = st_within)
st_filter(counties, sites)

counties |>
  group_by(region) |>
  summarise(n = n())

# s2 has no st_crosses() or st_overlaps() method, and no st_concave_hull(),
# st_area() or st_length(), so those have no applicable method here
