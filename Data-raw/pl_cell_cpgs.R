## code to get cell reference cpgs
library(tidyverse)

pl_cell_cpgs_third <-
  read_csv('Z:/Victor/Projects/NIH - cells/Manuscript/data/2_14_deconvolution_reference_cpgs_third.csv')

pl_cell_cpgs_first <-
  read_csv('Z:/Victor/Projects/NIH - cells/Manuscript/data/2_14_deconvolution_reference_cpgs_first.csv')


usethis::use_data(pl_cell_cpgs_third, pl_cell_cpgs_first, overwrite = TRUE, internal = FALSE)
