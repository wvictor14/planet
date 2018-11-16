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

    ## Warning: package 'iterators' was built under R version 3.5.1

    library(wateRmelon)

    ## Warning: package 'ggplot2' was built under R version 3.5.1

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
    ##                              Predicted_ethnicity Prob_African   Prob_Asian
    ## GSM1944959_9376561070_R05C01               Asian  0.012630828 0.9570737363
    ## GSM1944960_9376561070_R06C01           Caucasian  0.015919779 0.1713318381
    ## GSM1944961_9376561070_R01C02               Asian  0.021703784 0.9103326732
    ## GSM1944962_9376561070_R02C02           Caucasian  0.000726820 0.0007070925
    ## GSM1944963_9376561070_R03C02           Caucasian  0.002583857 0.0031621865
    ## GSM1944964_9376561070_R04C02           Caucasian  0.006235280 0.0115791460
    ##                              Prob_Caucasian Highest_Prob
    ## GSM1944959_9376561070_R05C01     0.03029544    0.9570737
    ## GSM1944960_9376561070_R06C01     0.81274838    0.8127484
    ## GSM1944961_9376561070_R01C02     0.06796354    0.9103327
    ## GSM1944962_9376561070_R02C02     0.99856609    0.9985661
    ## GSM1944963_9376561070_R03C02     0.99425396    0.9942540
    ## GSM1944964_9376561070_R04C02     0.98218557    0.9821856

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
