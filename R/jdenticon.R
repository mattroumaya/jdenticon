#' Create a Jdenticon.
#'
#' @param value `character` Value to be converted to hexadecimal hash to render Jdenticon.
#' @param filePath `character` File path to save Jdenticon .png to. If `NULL`, defaults to current working directory.
#' @param fileName `character` File name to save Jdenticon .png as. If `NULL`, defaults to `temp_jdenticon_{value}`.
#' @param size `numeric` Size of Jdenticon. Default == 100.
#' @param config list of jdenticon configuration options (see [the jdenticon documentation](https://jdenticon.com/js-api/M_jdenticon_toPng.html))
#' @param type Image type (default 'png', or 'svg')
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
    filePath = tempdir(),
    fileName = glue::glue('jdenticon_{size}_{value}'),
    size = "100",
    config = NULL,
    type = 'png',
    preview = interactive() && Sys.getenv("RSTUDIO") == "1")
  {

  if(!(type %in% c('png','svg')) )
    stop('Argument type must be one of "png" or "svg".')

  if (is.null(value)) {
    value <- rawToChar(as.raw(sample(c(65:90,97:122), 9, replace=TRUE)))
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

  config_json <- jsonlite::toJSON(config, auto_unbox = TRUE) |> as.character()

  console.log <- processx::run(
    command = "node",
    args = c(
      "built/index.js",
      filePath,
      fileName,
      size,
      value,
      config_json,
      type),
    wd = system.file("node", package = "jdenticon")
  )[["stdout"]]

  if (preview) {
    print(magick::image_read(glue::glue('{filePath}/{fileName}.{type}')))
  }

  return(
    glue::glue_collapse(console.log, sep = "\n")
  )

}
