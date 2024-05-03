#' Adjust compound concentrations for extracted tissue mass
#'
#' 'adjust_conc_for_tissue_mass()' accepts compound concentration data from
#'   chromatography and calculates the concentration of each compound in
#'   extracted tissue.
#'
#' @param data A data frame containing compound concentrations.
#' @param tiss_mass A vector of tissue mass extracted for each sample in data.
#' @param extract_vol Total volume of lipid extract.
#' @param prop_deriv Proportion of total lipid extract derivatized.
#' @param ... Additional arguments passed to methods.
#'
#' @return A data frame of tissue compound concentrations.
#' @export
#'
#' @examples
#'  #example data
#' data <- data.frame(
#'   runif(5, min = 1, max = 10),
#'   runif(5, min = 1, max = 10),
#'   runif(5, min = 1, max = 10)
#' )
#' names(data) <- c("8:0", "10:0", "12:0")
#' tiss_mass <- rep(10, 5)
#'
#' # Adjust concentration for tissue mass
#' adjust_conc_for_tissue_mass(data, tiss_mass)
#'
adjust_conc_for_tissue_mass <- function(
  data,
  tiss_mass,
  extract_vol = 1.5,
  prop_deriv = (1 / 1.5)
) {

  if (!length(tiss_mass) == length(data[, 1])) {
    stop("Number of samples (rows) in data does not match length of tiss_mass.")
  }

  # Divide ea. col in data by extracted tissue mass
  data <- data / tiss_mass

  # Adjust for vol of lipid extract & amount used for derivatization
  data <- data * (extract_vol / prop_deriv)

  # Return
  data
}