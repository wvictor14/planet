## code to get cell reference cpgs
library(tidyverse)

plCellCpGsThird <-
  read_csv('Z:/Victor/Projects/NIH - cells/outs/2_14_deconvolution_reference_cpgs_third.csv')

plCellCpGsFirst <-
  read_csv('Z:/Victor/Projects/NIH - cells/outs/2_14_deconvolution_reference_cpgs_first.csv')

# convert to matrix
plCellCpGsThird <- plCellCpGsThird[,2:7] %>%
  as.matrix() %>%
  magrittr::set_rownames(plCellCpGsThird$cpg)

plCellCpGsFirst <- plCellCpGsFirst[,2:7] %>%
  as.matrix() %>%
  magrittr::set_rownames(plCellCpGsFirst$cpg)

usethis::use_data(plCellCpGsThird, plCellCpGsFirst, overwrite = TRUE, internal = FALSE)

## Code for cell palette
plColors <- c(Syncytiotrophoblast = "#f4702e", 
               Trophoblasts = "#FBC02D", 
               Stromal = "#388E3C", 
               Hofbauer = "#1565C0", 
               Endothelial = "#6A1B9A", 
               nRBC = "grey")

usethis::use_data(plColors, internal = FALSE, overwrite =TRUE)
