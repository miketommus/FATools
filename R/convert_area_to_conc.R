#' Convert chromatogram peak area into concentration
#'
#' 'convert_area_to_conc' converts chromatogram peak areas into concentrations
#'   using an instrument response factor (RF) table for the external standards
#'   run during batch processing. The function can also map RF values for fatty
#'   acids (FA) not in external standards by passing in an RF mapping data
#'   frame.
#'
#' @param data A data frame containing peak areas.
#' @param rf_table A data frame containing instrument response factors.
#' @param ... Additional arguments passed to methods.
#' @param rf_map A data frame containing response factor mappings.
#'
#' @return A data frame containing peak concentrations.
#' @export
#'
#' @examples
#' # Add some examples
#'
convert_area_to_conc <- function(data, rf_table, ..., rf_map = NULL) {
  # Only runs if rf_map is provided
  if (!is.null(rf_map)) {
    # For ea row in rf_table that is 0||NA, use rf_map to add RF from
    # representative FA into rf_table
    for (i in 1:nrow(rf_table)) {
      if (rf_table$rf[i] == 0 || is.na(rf_table$rf[i])) {
        rf_table$rf[i] <- rf_table$rf[
          match(
            rf_map$ref_fa[match(rf_table$fa[i], rf_map$fa)],
            rf_table$fa
          )
        ]
      } else {
        # do nothing
      }
    }
  }

  # For ea. column of data, divide RF into all rows
  for (i in 1:ncol(data)) {
    # Get FA name from colname
    fa <- (colnames(data[i]))

    # Lookup RF value for FA in rf_table
    rf <- rf_table$rf[match(fa, rf_table$fa)]

    # Divide all rows in col by RF.
    data[i] <- data[i] / rf
  }

  # Return concentration data
  data
}

# # test data
# data <- test_sample_areas
# # test rf_table
# rf_table <- FATools::calc_gc_response_factor(
#   test_ext_std_areas,
#   c(15, 50, 100, 250),
#   test_nucheck_566c
# )
# # test rf map
# rf_map <- test_rf_map

test_results <- convert_area_to_conc(data, rf_table, rf_map = rf_map)
test_results2 <- convert_area_to_conc(data, rf_table)
n <- test_results == test_results2
