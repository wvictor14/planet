#' @title CpGs to predict ethnicity
#'
#' @description 1860 CpGs used to predict ethnicity. 
#' 
#' See [Yuan et al. 2019](https://pubmed.ncbi.nlm.nih.gov/31399127/) for 
#' details.
#'
#' @format A character vector of length 1860
#' @source \url{https://pubmed.ncbi.nlm.nih.gov/31399127/}
#' @usage data(ethnicityCpGs)
"ethnicityCpGs"

#' @title Example placental DNA methylation data
#'
#' @description 6 DNA methylation profiles from preeclampsia and healthy 
#' control placentas. This data was downloaded from:
#' 
#' - [GSE75196](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE75196)
#' 
#' "Genome wide DNA methylation profiling of normal and 
#' preeclampsia placental samples. Illumina Infinium HumanMethylation450 
#' BeadChip (450K array) was used to obtain DNA methylation profiles in 
#' placental samples. Samples included 16 samples from healthy uncomplicated
#'  pregnancies and 8 samples from pregnancies affected by preeclampsia." - 
#'  from [Yeung et al.](https://pubmed.ncbi.nlm.nih.gov/26968548/)
#'
#' The DNA methylation data for 24 placental samples were downloaded from
#' [GSE75196](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE75196).
#' After normalizing using `minfi::preprocessNoob` and `wateRmelon::BMIQ`, 
#' the data were filtered to 6/24 samples and 10,000 random CpGs + those CpGs 
#' used in the gestational age clock and ethnicity classifier.
#'
#' Reference: Yeung KR, Chiu CL, Pidsley R, Makris A et al. DNA methylation
#' profiles in preeclampsia and healthy control placentas. Am J Physiol Heart
#' Circ Physiol 2016 May 15;310(10):H1295-303.
#' [PMID:26968548](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE75196)
#'
#' @format A matrix
#' @source \url{https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE75196}
#' @usage data(plBetas)
"plBetas"

#' @title Sample information accompanying `pl_betas`
#' 
#' @description Sex, disease, and gestational age information associated with
#' `pl_betas`.
#'
#' Downloaded from the GEO accession:
#'  
#' - [GSE75196](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE75196)
#' 
#' Reference: Yeung KR, Chiu CL, Pidsley R, Makris A et al. DNA methylation
#' profiles in preeclampsia and healthy control placentas. Am J Physiol Heart
#' Circ Physiol 2016 May 15;310(10):H1295-303.
#' [PMID: 26968548](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE75196)
#' 
#' @format A [tibble][tibble::tibble-package]
#' @source \url{https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE75196}
#' @usage data(plPhenoData)
"plPhenoData"

#' @title Placental gestational age CpGs 
#' 
#' @description Coefficients from the three placental gestational age clocks 
#' from [Lee Y et al. 2019](https://pubmed.ncbi.nlm.nih.gov/31235674/).
#'
#' Reference: Lee Y, Choufani S, Weksberg R, et al. Placental epigenetic 
#' clocks: estimating gestational age using placental DNA methylation levels. 
#' Aging (Albany NY). 2019;11(12):4238–4253. doi:10.18632/aging.102049. PMID:
#' 31235674
#'
#' @format A [tibble][tibble::tibble-package] with coefficients for the RPC,
#' CPC, and refined RPC.
#' @usage data(ageCpGs)
"ageCpGs"

#' @title First trimester placental cell type coefficients
#' @description First trimester coefficients for placental cellular
#' deconvolution from [Yuan V et al. 2020]().
#'
#' Reference: to be edited
#' PMID: to be edited
#'
#' @format A [matrix] with coefficients for Trophoblasts, Stromal,
#' Endothelial, Hofbauer cells, nRBCs, and Syncytiotrophoblasts.
#' @usage data(plCellCpGsFirst)
"plCellCpGsFirst"

#' @title Third trimester placental cell type coefficients
#' @description Third trimester coefficients for placental cellular
#' deconvolution from [Yuan V et al. 2020]().
#'
#' Reference: to be edited
#' PMID: to be edited
#'
#' @format A [matrix] with coefficients for Trophoblasts, Stromal,
#' Endothelial, Hofbauer cells, nRBCs, and Syncytiotrophoblasts.
#' @usage data(plCellCpGsThird)
"plCellCpGsThird"

#' @title A color palette for placental cell types
#' @description A nice color palette for placental cell types. 
#' 
#' Used in [Yuan V et al. 2020]().
#' 
#' Contains colors for:
#'
#' - Syncytiotrophoblast
#' - Trophoblast
#' - Stromal
#' - Hofbauer
#' - Endothelial
#' - nRBCs
#' @usage data(plColors)
"plColors"