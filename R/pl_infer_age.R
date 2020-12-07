#' Predicts gestational age using DNA methylation microarray data
#' 
#' \code{pl_infer_age} Multiplies the coefficients from one of three epigenetic gestational age 
#' clocks by the corresponding CpGs in a supplied betas `data.frame`. 
#'
#' @param betas An n by m dataframe of methylation values on the beta scale (0, 1), where the 
#' CpGs are arranged in rows, and samples in columns. Should contain all CpGs used in each clock
#' @param type One of the following: "RPC" (Robust), "CPC", (Control) or "RRPC" (Refined Robust). 
#' 
#' @details Predicts gestational age using one of 3 placental gestational age clocks: RPC, CPC, or 
#' refined RPC. Requires placental DNA methylation measured on the Infinium 27K/450k/EPIC 
#' methylation array. If CpGs are missing, a warning is returned. 
#'
#' @return A vector of length `m`, containing inferred gestational age. `
#' 
#' @examples
#'
#' # Load placenta DNAm data
#' library(dplyr)
#' data(pl_betas)
#' data(pl_pDat)
#' 
#' pl_pDat %>%
#'   mutate(inferred_ga = pl_infer_age(pl_betas, type = 'RPC'))
#'
#' @export
#' 
pl_infer_age <- function(betas, type = 'RPC') {
  
  RPC <- CPC <- RRPC <- CpGs <- NULL
  
  # Filter to coefficients
  if (type == 'RPC') {
    coef <- planet::pl_clock %>% 
      dplyr::filter(RPC != 0)
  } else if (type == 'CPC') {
    coef <- planet::pl_clock %>% 
      dplyr::filter(CPC != 0)
  } else if (type == 'RRPC') {
    coef <- planet::pl_clock %>% 
      dplyr::filter(RRPC != 0)
  } else {
    stop('Type must be one of "CPC", "RPC", or "RRPC"')
  }
  
  cpgs <- intersect(coef %>% 
                      dplyr::filter(CpGs != '(Intercept)') %>% 
                      dplyr::pull(CpGs), 
                    rownames(betas))
  
  # Check if CpGs missing
  if (length(cpgs) < (nrow(coef)-1)) {
    warning(paste('Only', length(cpgs), 'out of', (nrow(coef)-1), 'predictors present.'))
  } else {
    print(paste(length(cpgs), 'of', (nrow(coef)-1), 'predictors present.'))
  }
  
  betas <- cbind(1, t(betas[cpgs,]))
  age <- betas %*% (coef %>% dplyr::pull(!!type)) %>% 
    as.vector
  
  return(age)
}