#' Install jdenticon npm dependency.
#'
#' @param force `boolean` If `TRUE`, automatically proceeds with npm installation. If `FALSE` (default), prompts user before proceeding with npm installation.
#'
#' @return Updated `inst/node_modules` folder.
#'
#' @examples
#' \dontrun{
#' jdenticon_npm_install(force = TRUE)
#' }
#'
#' @importFrom yesno yesno
#' @importFrom processx run
#'
#' @export
jdenticon_npm_install <- function(
    force = FALSE
){
  # Prompt the users unless they bypass (we're installing stuff on their machine)
  if (!force) {
    ok <- yesno::yesno("This will install the jdenticon library on your local directory. Ok to proceed? ")
  } else {
    ok <- TRUE
  }

  # If user is ok, run npm install in the node folder in the package folder
  # We should also check that the infra is not already there
  if (ok){
    processx::run(
      command = "npm",
      args = c("install"),
      wd = system.file("node", package = "jdenticon")
    )
  }
  return(invisible(force))
}
