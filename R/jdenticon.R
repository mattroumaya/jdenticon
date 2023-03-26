#' Create a Jdenticon.
#'
#' @param value `character` Value to be converted to hexadecimal hash to render Jdenticon.
#' @param filePath `character` File path to save Jdenticon .png to. If `NULL`, defaults to current working directory.
#' @param fileName `character` File name to save Jdenticon .png as. If `NULL`, defaults to `temp_jdenticon_{value}`.
#' @param size `numeric` Size of Jdenticon. Default == 100.
#' @param preview `boolean` Preview Jdenticon in viewer pane?
#'
#'
#' @examples
#' \dontrun{
#' jdenticon(value = 'mango')
#' }
#'
#' @return Jdenticon Icon.
#'
#' @importFrom glue glue_collapse
#' @importFrom fs path_abs
#' @importFrom processx run
#' @importFrom magick image_read
#'
#'
#' @export
jdenticon <- function(
    value = NULL,
    filePath = NULL,
    fileName = NULL,
    size = "100",
    preview = TRUE)
  {

  if (is.null(value)) {
    value <- rawToChar(as.raw(sample(c(65:90,97:122), 9, replace=T)))
  }

  if (is.null(filePath)) {
    filePath <- fs::path_abs(getwd())
  } else {
    # filePath arg
    filePath <- fs::path_abs(filePath)
  }

  if (is.null(fileName)) {
    fileName <- paste0("temp_jdenticon_", value)
  }

  console.log <- processx::run(
    command = "node",
    args = c(
      "script/index.js",
      filePath,
      fileName,
      size,
      value),
    wd = system.file("node", package = "jdenticon")
  )[["stdout"]]

  if (preview) {
    print(magick::image_read(paste0(filePath, "/", fileName, ".png")))
  }

  return(
    glue::glue_collapse(console.log, sep = "\n")
  )

}
