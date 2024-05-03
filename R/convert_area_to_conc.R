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
#'# example compound peak area data
#'data <- data.frame(
#'  runif(5, min = 1000, max = 3000000),
#'  runif(5, min = 1000, max = 3000000),
#'  runif(5, min = 1000, max = 3000000),
#'  runif(5, min = 1000, max = 3000000),
#'  runif(5, min = 1000, max = 3000000),
#'  runif(5, min = 1000, max = 3000000)
#')
#'names(data) <- c("8:0", "10:0", "12:0", "14:0", "i-15:0", "15:0")
#'
#'# example response factor table
#'rf_table <- data.frame(
#'  fa = c("10:0", "8:0", "12:0", "14:0", "i-15:0", "15:0"),
#'  rf = c(15000, 15000, 16000, 12000, 0, 10000)
#')
#'
#'# example response factor map
#'rf_map <- data.frame(
#'  fa = c("8:0", "10:0", "12:0", "14:0", "i-15:0", "15:0"),
#'  ref_fa = c(NA, NA, NA, NA, "15:0", NA)
#')
#'
#'# Convert areas to concentration
#'convert_area_to_conc(data, rf_table, rf_map = rf_map)
#'
convert_area_to_conc <- function(data, rf_table, ..., rf_map = NULL) {

  # Check that RF table matches FA in data
  if (!all(sort(colnames(data)) == sort(rf_table$fa))) {
    stop("Compounds in rf_table do not match compounds in data.")
  }

  # Only runs if rf_map is provided
  if (!is.null(rf_map)) {
    # For ea row in rf_table
    for (i in 1:nrow(rf_table)) {
      # If 0||NA, use rf_map to add RF from representative FA into rf_table
      if (rf_table$rf[i] == 0 || is.na(rf_table$rf[i])) {
        rf_map_indx <- match(rf_table$fa[i], rf_map$fa)
        # If FA is found in rf_map
        if (!is.na(rf_map_indx)) {
          rf_table$rf[i] <- rf_table$rf[
            match(rf_map$ref_fa[rf_map_indx], rf_table$fa)
          ]
        } else {
          stop(paste0("Compound ", rf_table$fa[i], " was not found in rf_map."))
        }
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