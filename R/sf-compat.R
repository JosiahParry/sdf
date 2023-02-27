combine_geometry.sfc <- function(x) sf::st_combine(x)

union_geometry.sfc <- function(x) sf::st_union(x)

simplify_geometry.sfc <- function(x) sf::st_simplify(x, ...)

buffer_geometry.sfc <- function(x, distance, ...) sf::st_buffer(x, distance, ...)

bounding_box.sfc <- function(x) sf::st_bbox(x)

centroid.sfc <- function(x) sf::st_centroid(x)

convex_hull.sfc <- function(x) sf::st_convex_hull(x)


