#' Features from 450k/850k data used to predict ethnicity
#'
#' The features on the 450k/850k DNAm microarry used to predict ethnicity.
#'
#' @format A character vector of length 1860
#' @source \url{https://github.com/wvictor14/Ethnicity_Inference_450k}
#'
"pl_ethnicity_features"

#' 6 DNA methylation profiles from preeclampsia and healthy control placentas
#'
#' "Genome wide DNA methylation profiling of normal and preeclampsia placental samples. Illumina
#' Infinium HumanMethylation450 BeadChip (450K array) was used to obtain DNA methylation profiles
#' in placental samples. Samples included 16 samples from healthy uncomplicated pregnancies and 8
#' samples from pregnancies affected by preeclampsia."
#'
#' The DNA methylation data for 24 placental samples were downloaded from
#' [GSE75196](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE75196). After normalizing using
#' `minfi::preprocessNoob` and `wateRmelon::BMIQ`, the betas were filtered to 10,000 random CpGs +
#' those CpGs used in the gestational age clock and ethnicity classifier.
#'
#' Reference: Yeung KR, Chiu CL, Pidsley R, Makris A et al. DNA methylation profiles in preeclampsia
#' and healthy control placentas. Am J Physiol Heart Circ Physiol 2016 May 15;310(10):H1295-303.
#' PMID: 26968548
#'
#' @format A matrix
#' @source \url{https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE75196}
#'
"pl_betas"

#' Sex, disease, and gestational age information associated with `pl_betas`. Taken from
#' [GSE75196](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE75196).
#'
#' @format A [tibble][tibble::tibble-package]
#' @source \url{https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE75196}
#'
"pl_pDat"

#' Coefficients from the three placental gestational age clocks from Lee Y et al. 2019.
#'
#' Reference: Lee Y, Choufani S, Weksberg R, et al. Placental epigenetic clocks: estimating
#' gestational age using placental DNA methylation levels. Aging (Albany NY). 2019;11(12):4238–4253.
#'  doi:10.18632/aging.102049.
#' PMID: 31235674
#'
#' @format A [tibble][tibble::tibble-package] with coefficients for the RPC, CPC, and refined RPC.
"pl_clock"

#' First trimester coefficients for placental cellular deconvolution from Yuan V et al. 2020.
#'
#' Reference:
#' PMID:
#'
#' @format A [tibble][tibble::tibble-package] with coefficients for Trophoblasts, Stromal,
#' Endothelial, Hofbauer cells, and nRBCs.
"pl_cell_cpgs_first"

#' Third trimester coefficients for placental cellular deconvolution from Yuan V et al. 2020.
#'
#' Reference:
#' PMID:
#'
#' @format A [tibble][tibble::tibble-package] with coefficients for Trophoblasts, Stromal,
#' Endothelial, Hofbauer cells, and nRBCs.
"pl_cell_cpgs_third"

