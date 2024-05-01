#' Calculate gas chromatograph response factor
#'
#' 'calc_gc_response_factor()' calculates instrument response factors using
#'   integrated chromatogram peak areas and external standard concentrations.
#'
#' @param data A data frame containing integrated chromatogram peak areas for
#'  each fatty acid in external standards. Colnames must be fatty acid names.
#' @param ext_std_concs A numeric vector containing the concentrations of
#'  external standards in ng/uL.
#' @param ext_std_contents A data frame containing fatty acids in external
#'  standards and the proportion (decimal percentage) each fatty acid makes up
#'  of standards. Proportions must sum to 1.
#' @param ... Additional arguments passed to methods.
#'
#' @return A df.
#' @export
#'
#' @examples
#' # Provide some examples.
calc_gc_response_factor <- function(data, ext_std_concs, ext_std_contents) {

  # Creates empty data frame to hold instrument response factors (RF)
  rf_table <- data.frame(
    fa = factor(),
    rf = double()
  )

  # Iterates through all columns of data
  for (i in 1:ncol(data)) {
    name <- colnames(data)[i]

    if (!is.na(match(name, ext_std_contents$fa))) {
      # If FA is in ext standards, calc response factor & add to rf_table
      areas <- data[[i]]
      concs <- ext_std_concs * ext_std_contents$prop[
        match(name, ext_std_contents$fa)
      ]
      rf <- sum(areas * concs) / sum(concs^2)
      rf_table <- dplyr::add_row(rf_table, fa = name, rf = rf)
    } else {
      # If FA is not in ext standards, add RF = 0 to rf_table
      rf_table <- dplyr::add_row(rf_table, fa = name, rf = 0)
    }

    rm(name)
  }

  # Return the rf_table
  rf_table
}



# # Test data
# data <- data.frame(
#   c(150, 500, 1000, 2500),
#   c(150, 500, 1000, 2500),
#   c(150, 500, 1000, 2500)
# )
# colnames(
#   data
# ) <- c("8.0", "10.0", "16.0")

# ext_std_concs = c(15, 50, 100, 250)

# ext_std_contents = data.frame(
#   fa = c("8.0", "10.0", "16.0"),
#   prop = c(0.1, 0.3, 0.6)
# )

# test <- calc_gc_response_factor(data, ext_std_concs, ext_std_contents)
