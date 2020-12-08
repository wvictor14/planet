## code to get cell reference cpgs
library(tidyverse)

pl_cell_cpgs_third <-
  read_csv('Z:/Victor/Projects/NIH - cells/outs/2_14_deconvolution_reference_cpgs_third.csv')

pl_cell_cpgs_first <-
  read_csv('Z:/Victor/Projects/NIH - cells/outs/2_14_deconvolution_reference_cpgs_first.csv')

# convert to matrix
pl_cell_cpgs_third <- pl_cell_cpgs_third[,2:7] %>%
  as.matrix() %>%
  magrittr::set_rownames(pl_cell_cpgs_third$cpg)

pl_cell_cpgs_first <- pl_cell_cpgs_first[,2:7] %>%
  as.matrix() %>%
  magrittr::set_rownames(pl_cell_cpgs_first$cpg)

usethis::use_data(pl_cell_cpgs_third, pl_cell_cpgs_first, overwrite = TRUE, internal = FALSE)
