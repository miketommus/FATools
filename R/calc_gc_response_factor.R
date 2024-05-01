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
#' @return A data frame of fatty acids and their calculated response factors.
#' @export
#'
#' @examples
#' # Make example peak area results
#' peak_areas <- data.frame(
#'   c(59690, 197032, 394075, 1041447),
#'   c(124260, 410732, 851543, 2092255),
#'   c(249962, 869479, 1895680, 4448913)
#' )
#'
#' colnames(
#'   peak_areas
#' ) <- c("8.0", "10.0", "16.0")
#'
#' # Make example external standards proportions list
#' ext_standard_proportions <- data.frame(
#'   fa = c("8.0", "10.0", "16.0"),
#'   prop = as.numeric(c(0.01, 0.02, 0.05))
#')
#'
#' # Calculate response factors
#' calc_gc_response_factor(
#'   peak_areas,
#'   ext_std_concs = c(15, 50, 100, 250),
#'   ext_std_contents = ext_standard_proportions
#' )
#'
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

# test the function
# test_results <- calc_gc_response_factor(
#   test_gc_data_filt,
#   ext_std_concs = c(15, 50, 100, 250),
#   ext_std_contents = test_nucheck_566c
# )