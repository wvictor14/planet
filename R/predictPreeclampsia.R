#' @title predictPreeclampsia
#'
#' @description Uses 45 CpGs to predict early preeclampsia (PE delivered before or at 34 weeks of gestation)
#' on placental DNA methylation microarray data.
#'
#' @details Assigns the class labels "early-PE" or "normotensive" to each sample
#' and returns a class probability.
#'
#' It is recommended that users apply beta-mixture quantile normalization (BMIQ) to their data
#' prior to prediction. This was the normalization method used on the training data.
#' 
#' Fernández-Boyano, A.M. Inkster, V. Yuan, W.P. Robinson medRxiv 
#' 2023.05.17.23290125; doi: https://doi.org/10.1101/2023.05.17.23290125 
#'
#' @param betas matrix or array of methylation values on the beta scale (0, 1),
#' where the variables are arranged in rows, and samples in columns.
#' 
#' @param ... feeds into outersect function
#'
#' @return produces a list with components detailed in the `mixOmics::predict` R documentation
#'
#' @examples
#'
#' # To predict early preeclampsia on 450k/850k samples
#'
#' # Load data
#' library(ExperimentHub)
#' eh <- ExperimentHub()
#' query(eh, "eoPredData")
#' 
#' # test object
#' x_test <- eh[['EH8403']]
#' x_test %>% predictPreeclampsia()
#' 
#' @export predictPreeclampsia
#'
predictPreeclampsia <- function(betas, ...){
  
  # read in data to generate model
  eh <- ExperimentHub::ExperimentHub()
  mod <- eh[['EH8090']]
  trainCpGs <- colnames(mod$X)
  
  # check that there are no NAs in the predictors (or if there are, how many)
  peCpGs <- mixOmics::selectVar(mod)$name
  pp <- intersect(rownames(betas), peCpGs)
  
  if(length(pp) < length(peCpGs)){
    stop(paste(
      "Only", length(pp), "out of 45 predictive CpGs present. All 45 predictive CpGs are needed to run the function."
    ))
  } else {
    message(paste(length(pp), "of 45 predictive CpGs present."))
    message("BMIQ normalization is recommended for best results. If choosing other method, it is recommended to compare results to predictions on BMIQ normalized data.")
  }
  
  # set up data for prediction
  
  # if input data is missing any of the cpgs present in the training data, this function
  # adds the ones that are missing as NAs
  # necessary for `mixOmics::predict` to work
  
  outersect <- function(x, y) {
    sort(c(x[!x%in%y],
           y[!y%in%x]))
  }
  
  if(inherits(betas, 'matrix')){
    
  } else if (inherits(betas, 'array')) {
    
  } else {
    # throw an error
    print(paste0("Input data must be a matrix or an array"))
  }
  
  betasSubset <- betas[rownames(betas) %in% trainCpGs,]
  
  # order
  betasSubset <- betasSubset[drop=FALSE,trainCpGs, ]
  
  stopifnot(all(rownames(betasSubset) == trainCpGs))
  
  # predict
  out <- predict.mixo_spls(mod, t(betasSubset))
  
  # get class probabilities
  CP <- out$predict[,,1]
  CP <- t(apply(as.matrix(CP), 1, function(data) exp(data)/sum(exp(data))))
  CP <- as.data.frame(CP) %>% tibble::rownames_to_column("Sample_ID")
  CP$PE_Status <- CP$comp1
  CP <- CP %>%
    dplyr::mutate(PE_Status = dplyr::case_when(EOPE > 0.55 ~ "EOPE",
                                               EOPE < 0.55 ~ "Normotensive"))
  return(tibble::as_tibble(CP))
}

