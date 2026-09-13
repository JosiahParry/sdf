# geos backend
#
# A geos_geometry column is a geometry column. The predicates build an STRtree
# over `y` and query it with `x`, so they stay fast on large inputs.

library(sf)
library(geos)
library(dplyr)

# sdf is attached last on purpose: it masks sf's st_ functions, and the
# package attached last is the one that wins
library(sdf)

nc <- st_read(system.file("shape/nc.shp", package = "sf"), quiet = TRUE)

counties <- as_sdf(tibble(
  name = as.character(nc$NAME),
  region = ifelse(nc$CNTY_ID > 1900, "east", "west"),
  geometry = as_geos_geometry(st_geometry(nc))
))

sites <- as_sdf(tibble(
  id = 1:2,
  geometry = as_geos_geometry(st_sfc(
    st_point(c(-78.6, 35.8)),
    st_point(c(-80.8, 35.2)),
    crs = st_crs(nc)
  ))
))

is_geometry(sdf_geometry(counties))

# geos implements a wk handler, so st_extent() needs no method of its own
st_extent(sdf_geometry(counties))

st_collect(sdf_geometry(counties))

st_centroid(sdf_geometry(sites))
st_convex_hull(sdf_geometry(counties))
st_buffer(sdf_geometry(sites), 0.1)
st_union(sdf_geometry(counties))

st_intersects(sdf_geometry(sites), sdf_geometry(counties))

st_join(sites, counties, predicate = st_within)
st_filter(counties, sites)

counties |>
  group_by(region) |>
  summarise(n = n())

# geos has no st_area() or st_length() method here, so those two fall through
# with no applicable method rather than returning something approximate
