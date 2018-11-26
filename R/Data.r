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
#' The full 24-sample dataset was downloaded from GEO and saved as an minfi rgset object. 2/24 were
#' classified as Asians and the remaining 22/24 were Caucasian. To reduce memory usage, I filtered
#' the sample size to 8 samples including the 2 samples classified as Asians.
#'
#' Reference: Yeung KR, Chiu CL, Pidsley R, Makris A et al. DNA methylation profiles in preeclampsia
#' and healthy control placentas. Am J Physiol Heart Circ Physiol 2016 May 15;310(10):H1295-303.
#' PMID: 26968548
#'
#' @format An rgset object with 8 samples
#' @source \url{https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE75196}
#'
"pl_rgset"
