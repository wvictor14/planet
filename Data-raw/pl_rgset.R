## pl_rgset ---------------------------------------------------------------------------
library(GEOquery)
library(minfi)

# download IDATs
getGEOSuppFiles("GSE75196") # 377.7 MB
untar("GSE75196/GSE75196_RAW.tar", exdir = "GSE75196/idat")
head(list.files("GSE75196/idat", pattern = "idat"))

# unzip
idatFiles <- list.files("GSE75196/idat", pattern = "idat.gz$", full = TRUE)
sapply(idatFiles, gunzip, overwrite = TRUE)

#load into R
pl_rgset <- read.metharray.exp("GSE75196/idat")
pl_rgset # 24 samples, 42.7 MB

use_data(pl_rgset)
