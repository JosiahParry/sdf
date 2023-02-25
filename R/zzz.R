.onLoad <- function(...) {
  vctrs::s3_register("dplyr::select", "sdf")
  vctrs::s3_register("dplyr::group_by", "sdf")
  vctrs::s3_register("dplyr::summarise", "sdf")
}
