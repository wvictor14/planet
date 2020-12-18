## pl_rgset ---------------------------------------------------------------------------
library(GEOquery)
library(minfi)
library(wateRmelon)
library(tidyverse)
library(janitor)

# download IDATs
getGEOSuppFiles("GSE75196") # 377.7 MB
untar("GSE75196/GSE75196_RAW.tar", exdir = "GSE75196/idat")
head(list.files("GSE75196/idat", pattern = "idat"))

# unzip
idatFiles <- list.files("GSE75196/idat", pattern = "idat.gz$", full = TRUE)
sapply(idatFiles, gunzip, overwrite = TRUE)

#load into R
pl_rgset <- read.metharray.exp("GSE75196/idat")

# normalize
n <- minfi::preprocessNoob(pl_rgset)
b <- wateRmelon::BMIQ(n)

# SNP data
s <- getSnpBeta(pl_rgset)
plBetas <- rbind(b, s)

# filter
set.seed(1)
cpgs <- unique(c(pl_ethnicity_features,
                 pl_clock$CpGs[2:nrow(pl_clock)], # drop intercept
                 sample(rownames(plBetas), 10000),
                 rownames(pl_cell_cpgs_first),
                 rownames(pl_cell_cpgs_third)))

plBetas <- plBetas[cpgs,]

# get pData
plPhenoData <- read_tsv('ftp://ftp.ncbi.nlm.nih.gov/geo/series/GSE75nnn/GSE75196/matrix/GSE75196_series_matrix.txt.gz',
                skip = 31, n_max = 20)

# fix pDat
plPhenoData <- plPhenoData %>%

  # clean variable names
  mutate(Variable = gsub('!Sample_', '', `!Sample_geo_accession`),
         Variable = case_when(
           grepl('characteristics', Variable) ~ gsub('\\:.*', '', GSM1944936),
           TRUE ~ Variable
         )) %>%
  dplyr::select(Variable, everything(), -`!Sample_geo_accession`) %>%

  # transpose
  pivot_longer(cols = -Variable,
               names_to = 'sample_id',
               values_to = 'value') %>%
  pivot_wider(id_cols = sample_id,
              names_from = Variable,
              values_from = value) %>%
  dplyr::select(sample_id, Sex:`gestation (wk)`) %>%

  # fix values
  mutate_all(list(~ gsub('.*\\:\\s', '', .))) %>%
  mutate(`gestation (wk)` = as.numeric(`gestation (wk)`))

# order pDat by plBetas columns
colnames(plBetas) <- colnames(pl_rgset) <-str_extract(colnames(pl_rgset), 'GSM[^_]*')
plPhenoData <- plPhenoData %>%
  filter(sample_id %in% colnames(pl_rgset)) %>%
  mutate(sample_id = factor(sample_id, levels = colnames(pl_rgset))) %>%
  arrange(sample_id) %>%
  janitor::clean_names()

usethis::use_data(plBetas, overwrite = TRUE, internal = FALSE)
usethis::use_data(plPhenoData, overwrite = TRUE, internal = FALSE)
