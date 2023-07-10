



#' Templates to extend sfd
#'
#' These templates can be used to extend sdf by implementing a new compatible
#' geometry vector column.
#'
#' - `use_sdf_template_class()` will create an R script with the scaffolding
#' needed to implement your geometry class to be compatible with `sdf`.
#' - `use_sdf_template_zzz()` will create a `zzz.R` file that will export your
#' methods to be available to sdf.
#'
#' @param class a scalar character of the class name of your geometry class
#' @inheritParams usethis::use_template
#' @rdname templates
#' @export
use_sdf_template_class <- function(class,
                                   save_as = paste0("R/sdf-compat-", class, ".R"),
                                   open = TRUE) {

  rlang::check_installed("usethis", "to generate templates")
  stopifnot(is.character(class) && length(class) == 1)
  usethis::use_template(
    "new-class-compat.R",
    data = list("class_name" = class),
    package = "sdf",
    save_as = save_as,
    open = open
  )


}

#' @export
#' @rdname templates
use_sdf_template_zzz <- function(class, save_as = "R/zzz.R", open = TRUE) {
  rlang::check_installed("usethis", "to generate templates")
  stopifnot(is.character(class) && length(class) == 1)
  cli::cli_inform("Adding {.pkg vctrs} to {.file DESCRIPTION}")
  usethis::use_package("vctrs")
  usethis::use_template(
    "zzz.R",
    data = list("class_name" = class),
    save_as = save_as,
    package = "sdf",
    open = open
  )
}
