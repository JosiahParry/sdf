# NOTE: Delete any methods that you have not implemented

.onLoad <- function(libname, pkgname) {

  # required methods
  vctrs::s3_register("sdf::is_geometry", "{{class_name}}")
  vctrs::s3_register("sdf::bounding_box", "{{class_name}}")
  vctrs::s3_register("sdf::combine_geometry", "{{class_name}}")

  # main interface
  vctrs::s3_register("sdf::union_geometry", "{{class_name}}")
  vctrs::s3_register("sdf::simplify_geometry", "{{class_name}}")
  vctrs::s3_register("sdf::buffer_geometry", "{{class_name}}")
  vctrs::s3_register("sdf::centroid", "{{class_name}}")
  vctrs::s3_register("sdf::convex_hull", "{{class_name}}")
  vctrs::s3_register("sdf::concave_hull", "{{class_name}}")

  # predicates
  vctrs::s3_register("sdf::sdf_intersects", "{{class_name}}")
  vctrs::s3_register("sdf::sdf_contains", "{{class_name}}")
  vctrs::s3_register("sdf::sdf_within", "{{class_name}}")
  vctrs::s3_register("sdf::sdf_crosses", "{{class_name}}")
  vctrs::s3_register("sdf::sdf_covers", "{{class_name}}")
  vctrs::s3_register("sdf::sdf_covered_by", "{{class_name}}")
  vctrs::s3_register("sdf::sdf_equals", "{{class_name}}")
  vctrs::s3_register("sdf::sdf_disjoint", "{{class_name}}")
  vctrs::s3_register("sdf::sdf_touches", "{{class_name}}")
  vctrs::s3_register("sdf::sdf_overlaps", "{{class_name}}")

  # additional options
  vctrs::s3_register("sdf::sdf_area", "{{class_name}}")
  vctrs::s3_register("sdf::sdf_length", "{{class_name}}")

}


