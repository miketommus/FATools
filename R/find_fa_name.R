#' Find index of fatty acid name
#'
#' 'find_fa_name()' finds fatty acid names using regular
#'    expressions and returns a integer vector of
#'    indexes where fatty acid names were found.
#'
#' @param x A character vector.
#'
#' @return An integer vector of indexes where fatty acid names are found in x.
#' @export
#'
#' @examples
#' # Character vector containing some fatty acid names
#' x <- c("c16.1w7c", "not-a-fa", "sample_id", "18.0", "20_1_w9", "i 15:0")
#'
#' # Returns integer vector c(1L, 4L, 5L, 6L)
#' find_fa_name(x)

find_fa_name <- function(x) {
  # do tha thang
  grep("[1-9]?[0-9][[:punct:]][0-9][1-9]?", x)
}