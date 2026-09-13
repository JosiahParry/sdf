library(sf)
library(duckspatial)

# sdf is attached last on purpose: it masks sf's st_ functions, and the
# package attached last is the one that wins
library(sdf)

nc <- st_read(system.file("shape/nc.shp", package = "sf"), quiet = TRUE)
nc <- nc[, c("NAME", "geometry")]

sites <- st_sf(
  id = 1:2,
  geometry = st_sfc(
    st_point(c(-78.6, 35.8)),
    st_point(c(-80.8, 35.2)),
    crs = st_crs(nc)
  )
)

counties <- as_duckspatial_df(nc)
points <- as_duckspatial_df(sites)


# a predicate answers with the matching row pairs, as another lazy table
st_intersects(counties, points)
dplyr::collect(st_within(points, counties))

# the filter runs as a query and comes back lazy
kept <- st_filter(counties, points)
kept
ddbs_collect(kept, as = "tibble")

# ddbs_join() builds a plain JOIN, so duckspatial can only do an inner join.
# st_join() says so rather than handing back an inner join under the name of a
# left one, which is why join_type has to be given here
joined <- st_join(counties, points, join_type = "inner")
ddbs_collect(joined, as = "tibble")

try(st_join(counties, points))

# geoarrow comes back without a WKB round trip
ddbs_collect(kept, as = "geoarrow")

# the geometry operations are duckspatial's own: sdf covers the join, the
# filter and the predicates, and ddbs_* covers the rest
ddbs_centroid(counties)
ddbs_area(counties)
