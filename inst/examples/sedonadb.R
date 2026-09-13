# sedonadb backend
#
# A sedonadb_dataframe holds nothing in R: it is a handle on a dataframe inside
# the Sedona engine. The predicates return a join condition over the two
# tables, which is what sedonadb's own join takes, and the join and filter run
# inside the engine.

library(sf)
library(sedonadb)

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

counties <- as_sedonadb_dataframe(nc)
points <- as_sedonadb_dataframe(sites)

# neither frame holds a geometry column, so the data frame path never claims it
is_geometry(counties)

# sedonadb can join on a relationship but cannot be asked which rows matched,
# so there are no predicate methods here
try(st_intersects(counties, points))

# the filter is a semi join inside the engine and comes back as a dataframe
kept <- st_filter(counties, points)
kept
sd_collect(kept)

# sedonadb does both join types, so the default left join works here
joined <- st_join(counties, points)
sd_collect(joined)

sd_collect(st_join(counties, points, join_type = "inner"))

# sedonadb has no disjoint join condition, so st_disjoint() has no method and
# says so rather than answering wrongly
try(st_filter(counties, points, predicate = st_disjoint))

# the geometry operations are sedonadb's own: sdf covers the join, the filter
# and the predicates, and sd_sql() covers the rest
sd_to_view(counties, "counties", overwrite = TRUE)
sd_collect(sd_sql(
  'SELECT "NAME", ST_Area(geometry) AS area FROM counties LIMIT 5'
))
