#' Infers ethnicity using DNA methylation microarray data
#'
#' \code{pl_infer_ethnicity} Uses a glmnet model to predict ethnicity using DNA methylation data.
#'
#' @param betas n x m dataframe of methylation values on the beta scale (0, 1), where the variables
#' are arranged in rows, and samples in columns. Should contain all 1860 predictors and be
#' normalized with NOOB and BMIQ.
#' @param threshold A probability threshold ranging from (0, 1) to call samples 'ambiguous'.
#' Defaults to 0.75.
#' @details Predicts self-reported ethnicity from 3 classes: Africans, Asians, and Caucasians, using
#' placental DNA methylation data measured on the Infinium 450k/EPIC methylation array. Will return
#' membership probabilities that often reflect genetic ancestry composition.
#'
#' A glmnet model fit using the package caret is applied to the data. The input data should
#' contain all 1860 predictors of the final model.
#'
#' In some datasets I find that the predictions can become skewed towards one class without any
#' normalization. Therefore, I highly recommend normalizing before running the model, ideally with
#' NOOB and BMIQ because those were used on the training data.
#'
#' @return A m x 7 dataframe of predicted ethnicity information and associated probabilities.
#' @examples
#' ## To predict ethnicity on 450k/850k samples
#'
#' # Load placenta DNAm data
#' library(wateRmelon)
#' library(minfi)
#' data(pl_rgset)
#'
#' n <- minfi::preprocessNoob(pl_rgset)
#' b <- wateRmelon::BMIQ(n)                # normalize 450k/850k methylation data
#' s <- getSnpBeta(pl_rgset)               # 450k/850k SNP data
#'
#' testDat <- rbind(b, s)
#'
#' pl_infer_ethnicity(testDat)
#'
#' @export
#'
pl_infer_ethnicity <- function(betas, threshold = 0.75){

  pf <- intersect(rownames(betas), pl_ethnicity_features)
  if(length(pf) < length(pl_ethnicity_features)){
    warning(paste('Only', length(pf), 'out of', length(pl_ethnicity_features), 'present.'))
  } else {
    print(paste(length(pf), 'of 1860 predictors present.'))
  }

  # subset down to 1860 final features
  betas <- t(betas[pf,])

  #glmnet code:
  for (i in seq(nclass)) {
    kbeta <- methods::rbind2(a0[i, , drop = FALSE], nbeta[[i]])#was rbind2
    vnames <- dimnames(kbeta)[[1]]
    dimnames(kbeta) <- list(NULL, NULL)
    kbeta <- kbeta[, lamlist$left, drop = FALSE] %*% Matrix::Diagonal(x=lamlist$frac) +
      kbeta[, lamlist$right, drop = FALSE] %*% Matrix::Diagonal(x=1 - lamlist$frac)
    dimnames(kbeta) <- list(vnames, paste(seq(along = s)))
    nbeta[[i]] <- kbeta
  }

  if (inherits(betas, "sparseMatrix"))
    betas <- methods::as(betas, "dgCMatrix")
  npred <-nrow(betas) # number of samples
  dn <- list(names(nbeta), dimnames(nbeta[[1]])[[2]], dimnames(betas)[[1]])
  dp <- array(0, c(nclass, nlambda, npred), dimnames = dn) # set up for results output

  # cross product with coeeficients
  for (i in seq(nclass)) {
    fitk <- methods::cbind2(1, betas) %*% matrix(nbeta[[i]][c("(Intercept)", colnames(betas)),])
    dp[i, , ] = dp[i, , ] + t(as.matrix(fitk))
  }

  #probabilities
  pp <- exp(dp)
  psum <- apply(pp, c(2, 3), sum)
  probs <- data.frame(aperm(pp/rep(psum, rep(nclass, nlambda * npred)), c(3, 1, 2)))
  colnames(probs) <- paste0('Prob_', dn[[1]])

  #classification
  link <- aperm(dp, c(3, 1, 2))
  dpp <- aperm(dp, c(3, 1, 2))
  preds <- data.frame(apply(dpp, 3, glmnet::glmnet_softmax))
  colnames(preds) <- 'Predicted_ethnicity_nothresh'

  # combine and apply thresholding
  p <- cbind(preds, probs)
  p$Highest_Prob <- apply(p[,2:4], 1, max)
  p$Predicted_ethnicity <- ifelse(p$Highest_Prob < threshold, 'Ambiguous',
                                  as.character(p$Predicted_ethnicity_nothresh))
  p$Sample_ID <- rownames(p)
  p <- p[,c(7,1,6, 2:5)]

  return(p)
}
