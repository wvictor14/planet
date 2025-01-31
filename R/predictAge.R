#' @title Predicts gestational age using placental DNA methylation microarray 
#' data
#'
#' @description \code{predictAge} Multiplies the coefficients from one of three 
#' epigenetic gestational age clocks, by the corresponding CpGs in a supplied 
#' betas `data.frame`.
#' 
#' @details Predicts gestational age using one of 3 placental gestational age
#' clocks: RPC, CPC, or refined RPC. Requires placental DNA methylation measured
#' on the Infinium 27K/450k/EPIC methylation array. Ensure as many predictive
#' CpGs are present in your data, otherwise accuracy may be impacted.
#'
#' It's recommended that you have all predictive CpGs, otherwise accuracy may
#' vary.
#' 
#' @param betas An n by m dataframe of methylation values on the beta scale (0,
#' 1), where the CpGs are arranged in rows, and samples in columns. Should
#' contain all CpGs used in each clock
#' @param type One of the following: "RPC" (Robust), "CPC", (Control) or "RRPC"
#' (Refined Robust).
#' @return A vector of length `m`, containing inferred gestational age.
#'
#' @examples
#'
#' # Load placenta DNAm data
#' library(dplyr)
#' data(plBetas)
#' data(plPhenoData)
#'
#' plPhenoData %>%
#'     mutate(inferred_ga = predictAge(plBetas, type = "RPC"))
#'     
#' @export predictAge
#' @export pl_infer_age
#' @aliases pl_infer_age
#' 
predictAge <- function(betas, type = "RPC") {
    data(ageCpGs, envir = environment())
    RPC <- CPC <- RRPC <- CpGs <- NULL
    # Filter to coefficients
    if (type == "RPC") {
        coef <- ageCpGs %>%
            dplyr::filter(RPC != 0)
    } else if (type == "CPC") {
        coef <- ageCpGs %>%
            dplyr::filter(CPC != 0)
    } else if (type == "RRPC") {
        coef <- ageCpGs %>%
            dplyr::filter(RRPC != 0)
    } else {
        stop('Type must be one of "CPC", "RPC", or "RRPC"')
    }

    # intersection of cpgs
    cpgs <- intersect(
        coef %>%
            dplyr::filter(CpGs != "(Intercept)") %>%
            dplyr::pull(CpGs),
        rownames(betas)
    )

    # Check if CpGs missing
    if (length(cpgs) / (nrow(coef) - 1) < 0.5) {
        stop("Less than 50% of predictors were found.")
    }


    if (length(cpgs) < (nrow(coef) - 1)) {
        warning(paste(
            "Only", length(cpgs), "out of", (nrow(coef) - 1),
            "predictors present."
        ))
    } else {
        message(paste(
            length(cpgs), "of",
            (nrow(coef) - 1), "predictors present."
        ))
    }

    # filter coefficients and beta
    coef_filtered <- coef %>%
        dplyr::filter(CpGs %in% c("(Intercept)", cpgs)) %>%
        dplyr::pull(!!type)

    betas_filtered <- cbind(1, t(betas[cpgs, ]))

    # calculate
    age <- betas_filtered %*% coef_filtered %>%
        as.vector()

    return(age)
}