#' Convert fatty acid names into common formats
#'
#' 'pretty_fa_names()' converts fatty acid names into commonly used formats and
#' provides the ability to easily customize how they are written.
#'
#' @param x A vector of fatty acid names.
#' @param style A number corresponding to a style table that dictates how names
#' will be converted. Defaults to "1".
#' @param notation A character vector that determines what precedes the
#' numerical representation of the location of double bonds.
#' @param sep A character vector that determines what separator is used
#' between carbon length and number of desaturations.
#'
#' @return A vector of reformatted names.
#' @export
#'
#' @examples
#' x <- c("c16.1w7c", "18.0", "20_1_w9")
#'
#' # returns c("16:1ω7c", "18:0", "20:1ω9")
#' pretty_fa_names(x)
#'
#' # returns c("16.1 (n-7) c", "18.0", "20.1 (n-9)")
#' pretty_fa_names(x, style = 3, notation = "n", sep = ".")

# Write a function
pretty_fa_names <- function(x, style = 1, notation = "\u03C9", sep = ":") {

  # Extract FA
  acids <- stringr::str_extract(x, "[1-9]?[0-9][[:punct:]][0-9][1-9]?")

  # extract omega
  omega <- "[wn\u03C9]+[-\\s]?[0-9]{1,2}"
  # Extract not
  not <- stringr::str_extract(stringr::str_extract(x, omega), "[a-z]|\u03C9")
  # Extract loc
  loc <- stringr::str_extract(stringr::str_extract(x, omega), "[0-9]+")

  # Extract config
  # config <- "cis|trans|c|t"   # nolint
  config <- stringr::str_extract(x, "(?<=[0-9]{1,2}.{0,2})(cis|trans|c|t)")

  # replaces not with notation
  not <- replace(not, !is.na(not), notation)

  # replaces separator with sep
  acids <- sub("[[:punct:]]", sep, acids)

  # reformat
  if (style == 1) {
    gsub_style(
      paste0(acids, not, loc, config) # e.g. 16:1w11c
    )
  } else if (style == 2) {
    gsub_style(
      paste0(acids, " ", not, loc, config) # e.g. 16:1 w11c
    )
  } else if (style == 3) {
    gsub_style(
      paste0(acids, " (", not, "-", loc, ") ", config) # e.g. 16:1 (w-11) c
    )
  } else if (style == 4) {
    gsub_style(
      paste0("C", acids, not, loc, config) # e.g. C16:1w11c
    )
  } else if (style == 5) {
    gsub_style(
      paste0("C", acids, " ", not, loc, config) # e.g. C16:1 w11c
    )
  } else if (style == 6) {
    gsub_style(
      paste0("C", acids, " (", not, "-", loc, ") ", config) # e.g. C16:1 (w-11) c
    )
  } else {
    # do nothing
  }
}

gsub_style <- function(style) {
  gsub(
    "\\s?NA|\\s?\\(NA-NA\\)", # removes NAs
    "",
    style
  )
}