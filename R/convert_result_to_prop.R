#' Convert chromatogram peak area or concentration into proportion
#'
#' 'convert_result_to_prop()' converts chromatogram compound areas and
#'   concentrations into proportions (decimal % of all compounds for each
#'   sample).
#'
#' @param data A data frame containing numberic data
#' @param na.rm Logical. If TRUE, excludes NA or NaN values from calculation.
#' @param... Other arguments to be passed to or from methods.
#'
#' @return A data frame containing compound proportions.
#' @export
#'
#' @examples
#' # example data
#' data <- data.frame(
#'   runif(5, min = 1000, max = 300000),
#'   runif(5, min = 1000, max = 300000),
#'   runif(5, min = 1000, max = 300000),
#'   runif(5, min = 1000, max = 300000),
#'   runif(5, min = 1000, max = 300000)
#' )
#' names(data) <- c("8:0", "10:0", "12:0", "13:0", "14:0")
#'
#' # Convert example data to proportions
#' convert_result_to_prop(data)
#'
convert_result_to_prop <- function(data, na.rm = TRUE) {
  # Poor man's input validation. Fix.
  if (!is.data.frame(data)) {
    stop("data must be of class 'data.frame'.")
  } else {
    # continue
  }

  # check for C19
  c19 <- sum(
    grepl("19:0", FATools::convert_fa_name(colnames(data))),
    na.rm = TRUE
  )
  if (c19 > 0) {
    stop("Please remove the internal standard 19:0 from your data.")
  }

  # Divide each data point by the sum of its row
  data <- data / rowSums(data, na.rm = na.rm)

  # Ensure rows sum to 1
  if (!sum(rowSums(data, na.rm = TRUE)) == length(data[,1])) {
    stop("Proportions do not sum to 1. Please check your data and rerun.")
  }

  # Return data
  data
}
