## code to get coefficients from Lee Y et al.
library(tidyverse)
ageCpGs <- read_csv('https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6628997/bin/aging-11-102049-s001.csv')

colnames(ageCpGs)[2:5] <- c('RPC', 'CPC', 'RRPC', 'Sex')

usethis::use_data(ageCpGs, overwrite = TRUE, internal = FALSE)
