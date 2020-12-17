#' @title \code{predictEthnicity}
#' 
#' @description Predicts ethnicity using DNA methylation microarray data
#'
#' \code{predictEthnicity} Uses a glmnet model to predict ethnicity using DNA
#' methylation data.
#'
#' @param betas n x m dataframe of methylation values on the beta scale (0, 1),
#' where the variables are arranged in rows, and samples in columns. Should
#' contain all 1860 predictors and be normalized with NOOB and BMIQ.
#' @param threshold A probability threshold ranging from (0, 1) to call samples
#' 'ambiguous'. Defaults to 0.75.
#' 
#' @details Predicts self-reported ethnicity from 3 classes: Africans, Asians,
#' and Caucasians, using placental DNA methylation data measured on the Infinium
#' 450k/EPIC methylation array. Will return membership probabilities that often
#' reflect genetic ancestry composition.
#'
#' The input data should contain all 1860 predictors (cpgs) of the final GLMNET
#' model.
#'
#' It's recommended to use the same normalization methods used on the training
#' data: NOOB and BMIQ.
#'
#' @return a [tibble][tibble::tibble-package]
#' @examples
#' ## To predict ethnicity on 450k/850k samples
#'
#' # Load placenta DNAm data
#' data(pl_betas)
#' predictEthnicity(pl_betas)
#' 
#' @export predictEthnicity 
#' @export pl_infer_ethnicity
#' @aliases pl_infer_ethnicity

predictEthnicity <- function(betas, threshold = 0.75) {
    pf <- intersect(rownames(betas), planet::pl_ethnicity_features)
    if (length(pf) < length(planet::pl_ethnicity_features)) {
        warning(paste(
            "Only", length(pf), "out of",
            length(planet::pl_ethnicity_features), "present."
        ))
    } else {
        message(paste(length(pf), "of 1860 predictors present."))
    }
    
    # subset down to 1860 final features
    betas <- t(betas[pf, ])
    
    npred <- nrow(betas) # number of samples
    dn <- list(names(nbeta), "1", dimnames(betas)[[1]])
    dp <- array(0, c(nclass, nlambda, npred), dimnames = dn) # set up results
    
    # cross product with coeeficients
    for (i in seq(nclass)) {
        fitk <- methods::cbind2(1, betas) %*%
            matrix(nbeta[[i]][c("(Intercept)", colnames(betas)), ])
        dp[i, , ] <- dp[i, , ] + t(as.matrix(fitk))
    }
    
    # probabilities
    pp <- exp(dp)
    psum <- apply(pp, c(2, 3), sum)
    probs <- data.frame(aperm(
        pp / rep(psum, rep(nclass, nlambda * npred)),
        c(3, 1, 2)
    ))
    colnames(probs) <- paste0("Prob_", dn[[1]])
    
    # classification
    link <- aperm(dp, c(3, 1, 2))
    dpp <- aperm(dp, c(3, 1, 2))
    preds <- data.frame(apply(dpp, 3, glmnet_softmax))
    colnames(preds) <- "Predicted_ethnicity_nothresh"
    
    # combine and apply thresholding
    p <- cbind(preds, probs)
    p$Highest_Prob <- apply(p[, 2:4], 1, max)
    p$Predicted_ethnicity <- ifelse(
        p$Highest_Prob < threshold, "Ambiguous",
        as.character(p$Predicted_ethnicity_nothresh)
    )
    p$Sample_ID <- rownames(p)
    p <- p[, c(7, 1, 6, 2:5)]
    
    return(tibble::as_tibble(p))
}

# attribution to glmnet v3.0.2
glmnet_softmax <- function(x, ignore_labels = FALSE) {
    d <- dim(x)
    dd <- dimnames(x)[[2]]
    if (is.null(dd) || !length(dd)) {
        ignore_labels <- TRUE
    }
    
    nas <- apply(is.na(x), 1, any)
    if (any(nas)) {
        pclass <- rep(NA, d[1])
        if (sum(nas) < d[1]) {
            pclass2 <- glmnet_softmax(x[!nas, ], ignore_labels)
            pclass[!nas] <- pclass2
            if (is.factor(pclass2)) {
                pclass <- factor(
                    pclass,
                    levels = seq(d[2]),
                    labels = levels(pclass2)
                )
            }
        }
    } else {
        maxdist <- x[, 1]
        pclass <- rep(1, d[1])
        for (i in seq(2, d[2])) {
            l <- x[, i] > maxdist
            pclass[l] <- i
            maxdist[l] <- x[l, i]
        }
        dd <- dimnames(x)[[2]]
        if (!ignore_labels) {
            pclass <- factor(pclass, levels = seq(d[2]), labels = dd)
        }
    }
    pclass
}

pl_infer_ethnicity <- function(betas, threshold = 0.75) {
    .Deprecated("predictEthnicity")
    predictEthnicity(betas = betas, threshold = threshold)
}
