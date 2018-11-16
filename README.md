-   [pl\_infer\_ethnicity](#pl_infer_ethnicity)
    -   [Install](#install)
    -   [Use](#use)

pl\_infer\_ethnicity
====================

For inferring ethnicity from placental DNA methylation microarray data.

### Install

    library(devtools)
    install_github('wvictor14/plmec')

### Use

#### Example Data

For examples I download some [placental DNAm GEO
data](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE75196) from
an study including Australian samples. I only use 8/24 samples here, to
save on memory.

    library(plmec)
    library(minfi)

    ## Loading required package: BiocGenerics

    ## Loading required package: parallel

    ## 
    ## Attaching package: 'BiocGenerics'

    ## The following objects are masked from 'package:parallel':
    ## 
    ##     clusterApply, clusterApplyLB, clusterCall, clusterEvalQ,
    ##     clusterExport, clusterMap, parApply, parCapply, parLapply,
    ##     parLapplyLB, parRapply, parSapply, parSapplyLB

    ## The following objects are masked from 'package:stats':
    ## 
    ##     IQR, mad, sd, var, xtabs

    ## The following objects are masked from 'package:base':
    ## 
    ##     anyDuplicated, append, as.data.frame, basename, cbind,
    ##     colMeans, colnames, colSums, dirname, do.call, duplicated,
    ##     eval, evalq, Filter, Find, get, grep, grepl, intersect,
    ##     is.unsorted, lapply, lengths, Map, mapply, match, mget, order,
    ##     paste, pmax, pmax.int, pmin, pmin.int, Position, rank, rbind,
    ##     Reduce, rowMeans, rownames, rowSums, sapply, setdiff, sort,
    ##     table, tapply, union, unique, unsplit, which, which.max,
    ##     which.min

    ## Loading required package: GenomicRanges

    ## Loading required package: stats4

    ## Loading required package: S4Vectors

    ## 
    ## Attaching package: 'S4Vectors'

    ## The following object is masked from 'package:base':
    ## 
    ##     expand.grid

    ## Loading required package: IRanges

    ## 
    ## Attaching package: 'IRanges'

    ## The following object is masked from 'package:grDevices':
    ## 
    ##     windows

    ## Loading required package: GenomeInfoDb

    ## Loading required package: SummarizedExperiment

    ## Loading required package: Biobase

    ## Welcome to Bioconductor
    ## 
    ##     Vignettes contain introductory material; view with
    ##     'browseVignettes()'. To cite Bioconductor, see
    ##     'citation("Biobase")', and for packages 'citation("pkgname")'.

    ## Loading required package: DelayedArray

    ## Loading required package: matrixStats

    ## 
    ## Attaching package: 'matrixStats'

    ## The following objects are masked from 'package:Biobase':
    ## 
    ##     anyMissing, rowMedians

    ## Loading required package: BiocParallel

    ## 
    ## Attaching package: 'DelayedArray'

    ## The following objects are masked from 'package:matrixStats':
    ## 
    ##     colMaxs, colMins, colRanges, rowMaxs, rowMins, rowRanges

    ## The following objects are masked from 'package:base':
    ## 
    ##     aperm, apply

    ## Loading required package: Biostrings

    ## Loading required package: XVector

    ## 
    ## Attaching package: 'Biostrings'

    ## The following object is masked from 'package:DelayedArray':
    ## 
    ##     type

    ## The following object is masked from 'package:base':
    ## 
    ##     strsplit

    ## Loading required package: bumphunter

    ## Loading required package: foreach

    ## Loading required package: iterators

    ## Warning: package 'iterators' was built under R version 3.5.1

    ## Loading required package: locfit

    ## locfit 1.5-9.1    2013-03-22

    ## Setting options('download.file.method.GEOquery'='auto')

    ## Setting options('GEOquery.inmemory.gpl'=FALSE)

    library(wateRmelon)

    ## Loading required package: limma

    ## 
    ## Attaching package: 'limma'

    ## The following object is masked from 'package:BiocGenerics':
    ## 
    ##     plotMA

    ## Loading required package: methylumi

    ## Loading required package: scales

    ## Loading required package: reshape2

    ## Loading required package: ggplot2

    ## Warning: package 'ggplot2' was built under R version 3.5.1

    ## Loading required package: FDb.InfiniumMethylation.hg19

    ## Loading required package: GenomicFeatures

    ## Loading required package: AnnotationDbi

    ## Loading required package: TxDb.Hsapiens.UCSC.hg19.knownGene

    ## Loading required package: org.Hs.eg.db

    ## 

    ## Loading required package: lumi

    ## 
    ## Attaching package: 'lumi'

    ## The following objects are masked from 'package:methylumi':
    ## 
    ##     estimateM, getHistory

    ## Loading required package: ROC

    ## Loading required package: IlluminaHumanMethylation450kanno.ilmn12.hg19

    ## Loading required package: illuminaio

    library(ggplot2)

    data(pl_rgset)
    pl_rgset # 8 samples

    ## class: RGChannelSet 
    ## dim: 622399 8 
    ## metadata(0):
    ## assays(2): Green Red
    ## rownames(622399): 10600313 10600322 ... 74810490 74810492
    ## rowData names(0):
    ## colnames(8): GSM1944959_9376561070_R05C01
    ##   GSM1944960_9376561070_R06C01 ... GSM1944965_9376561070_R05C02
    ##   GSM1944966_9376561070_R06C02
    ## colData names(0):
    ## Annotation
    ##   array: IlluminaHumanMethylation450k
    ##   annotation: ilmn12.hg19

Because the data used to train the ethnicity classifier was normalized,
I recommend using the same normalization procedures.

Here I we apply noob and BMIQ normalization to the methylation data, and
then combine this with the 65 snp probe data.

    #normalization
    pl_noob <- preprocessNoob(pl_rgset)

    ## Loading required package: IlluminaHumanMethylation450kmanifest

    ## [dyeCorrection] Applying R/G ratio flip to fix dye bias

    pl_bmiq <- BMIQ(pl_noob)

    ## 
    ## Attaching package: 'RPMM'

    ## The following object is masked from 'package:limma':
    ## 
    ##     ebayes

    #snp probes
    pl_snps <- getSnpBeta(pl_rgset)

    #combine methylation and genotyping data
    pl_dat <- rbind(pl_bmiq, pl_snps)
    dim(pl_dat) # 485577     8

    ## [1] 485577      8

#### Infer ethnicity

The reason we added the snp data onto the betas matrix was because a
subset of those are used to predict ethnicity. The input data needs to
contain all 1862 features in the final model. We can check this with the
pl\_ethnicity\_features vector.

    all(pl_ethnicity_features %in% rownames(pl_dat))

    ## [1] TRUE

You don't need to subset to these 1862 features before running
pl\_ethnicity\_infer():

    dim(pl_dat)

    ## [1] 485577      8

    results <- pl_infer_ethnicity(pl_dat)

    ## [1] "1862 of 1862 predictors present."

    head(results)

    ##                                                 Sample_ID
    ## GSM1944959_9376561070_R05C01 GSM1944959_9376561070_R05C01
    ## GSM1944960_9376561070_R06C01 GSM1944960_9376561070_R06C01
    ## GSM1944961_9376561070_R01C02 GSM1944961_9376561070_R01C02
    ## GSM1944962_9376561070_R02C02 GSM1944962_9376561070_R02C02
    ## GSM1944963_9376561070_R03C02 GSM1944963_9376561070_R03C02
    ## GSM1944964_9376561070_R04C02 GSM1944964_9376561070_R04C02
    ##                              Predicted_ethnicity_nothresh
    ## GSM1944959_9376561070_R05C01                        Asian
    ## GSM1944960_9376561070_R06C01                    Caucasian
    ## GSM1944961_9376561070_R01C02                        Asian
    ## GSM1944962_9376561070_R02C02                    Caucasian
    ## GSM1944963_9376561070_R03C02                    Caucasian
    ## GSM1944964_9376561070_R04C02                    Caucasian
    ##                              Predicted_ethnicity Prob_African  Prob_Asian
    ## GSM1944959_9376561070_R05C01               Asian 0.0108363827 0.955766512
    ## GSM1944960_9376561070_R06C01           Caucasian 0.0105432572 0.114481856
    ## GSM1944961_9376561070_R01C02               Asian 0.0223480174 0.885851476
    ## GSM1944962_9376561070_R02C02           Caucasian 0.0007165613 0.000718034
    ## GSM1944963_9376561070_R03C02           Caucasian 0.0019643319 0.002470725
    ## GSM1944964_9376561070_R04C02           Caucasian 0.0066539200 0.011746580
    ##                              Prob_Caucasian Highest_Prob
    ## GSM1944959_9376561070_R05C01     0.03339711    0.9557665
    ## GSM1944960_9376561070_R06C01     0.87497489    0.8749749
    ## GSM1944961_9376561070_R01C02     0.09180051    0.8858515
    ## GSM1944962_9376561070_R02C02     0.99856540    0.9985654
    ## GSM1944963_9376561070_R03C02     0.99556494    0.9955649
    ## GSM1944964_9376561070_R04C02     0.98159950    0.9815995

    qplot(data = results, x = Prob_Caucasian, y = Prob_African, 
         col = Predicted_ethnicity, xlim = c(0,1), ylim = c(0,1))

![](README_files/figure-markdown_strict/unnamed-chunk-5-1.png)

    qplot(data = results, x = Prob_Caucasian, y = Prob_Asian, 
         col = Predicted_ethnicity, xlim = c(0,1), ylim = c(0,1))

![](README_files/figure-markdown_strict/unnamed-chunk-5-2.png)

The results for the whole (n=24) dataset are 22/24 = predicted
Caucasian, 2/24 predicted Asian.

We can't compare this to self-reported ethnicity as it is unavailable.
But we know these samples were collected in Sydney, Australia, and are
therefore likely mostly European with some Asian ancestries.

    table(results$Predicted_ethnicity)

    ## 
    ##     Asian Caucasian 
    ##         2         6
