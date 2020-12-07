## code to get coefficients from Lee Y et al.
library(tidyverse)
pl_clock <- read_csv('https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6628997/bin/aging-11-102049-s001.csv')

colnames(pl_clock)[2:5] <- c('RPC', 'CPC', 'RRPC', 'Sex')

usethis::use_data(pl_clock, overwrite = TRUE, internal = FALSE)