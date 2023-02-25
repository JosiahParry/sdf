

#' @export
format.sdf <- function(x, ...) {
  geom_col <- attr(x, "geom_column")
  bbox <- attr(x, "bbox")

  geom_type <- paste0("Geometry Type: ", class(x[[geom_col]])[1])
  bbox_str <- paste0("Bounding box: ", paste(names(bbox), bbox, collapse = " ", sep = ": "))

  c(
    "geom" = geom_type,
    "bbox" =  bbox_str,
    NextMethod()
  )

}
