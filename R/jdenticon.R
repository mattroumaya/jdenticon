#' Create a Jdenticon.
#'
#' @param value `character` Value to be converted to hexadecimal hash to render Jdenticon. Cannot contain characters that are reserved for filepaths:
#'
#' @param filePath `character` File path to save Jdenticon .png to. If `NULL`, defaults to current working directory.
#' @param fileName `character` File name to save Jdenticon .png as. If `NULL`, defaults to `temp_jdenticon_{value}`.
#' @param size `numeric` Size of Jdenticon. Default == 100.
#' @param config list of jdenticon configuration options (see [the jdenticon documentation](https://jdenticon.com/js-api/M_jdenticon_toPng.html))
#' @param type Image type (default 'png', or 'svg')
#' @param preview `boolean` Preview Jdenticon in viewer pane?
#' @param return_list `boolean` Return full list object with all settings?
#'
#'
#' @examples
#' \dontrun{
#' jdenticon(value = 'mango')
#' }
#'
#' @return Path to Jdenticon icon file, or (if `return_list` is true) a list with all parameters (including path).
#'
#' @importFrom glue glue
#' @importFrom fs path_abs
#' @importFrom processx run
#' @importFrom magick image_read
#' @importFrom jsonlite fromJSON
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
    preview = interactive() && Sys.getenv("RSTUDIO") == "1",
    return_list = FALSE)
  {

  tryCatch(
    processx::run('node',args = '-v'),
    error = \(cond){
      print(cond)
      stop('There was a problem running node. Is it installed and on the path?', call. = FALSE)
    })

  if(!(type %in% c('png','svg')) )
    stop('Argument type must be one of "png" or "svg".')

  if (is.null(value)) {
    value <- rawToChar(as.raw(sample(c(65:90,97:122), 9, replace=TRUE)))
  } else {
    origValue <- value
    value <- gsub("[^[:alnum:]]+", "_", iconv(value, from = "ascii", "utf-8"))
    if (origValue != value) {
      warning(glue::glue("The value `{origValue}` contains at least one illegal character. Value used has been modified to `{value}`."))
    }
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

  tryCatch({
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
  },
  error = \(cond){
    print(cond)
    stop('There was a problem running jdenticon. Have you run jdenticon_npm_install()?', call. = FALSE)
  })

  params_list = jsonlite::fromJSON(console.log)

  if(!file.exists(params_list$fullPath))
    stop('Image was not created.')

  if (preview) {
      glue::glue('{filePath}/{fileName}.{type}') |>
        magick::image_read() |>
        print()
  }

  if(isTRUE(return_list)){
    return(params_list)
  }else{
    return(params_list$fullPath)
  }
}
