plmec
=====

`plmec` is an R package for inferring ethnicity from placental DNA
methylation microarray data.

Installation
------------

    library(devtools)
    install_github('wvictor14/plmec')

Usage
-----

### Example Data

For examples I download some [placental DNAm GEO
data](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE75196) from
an study including Australian samples. To save on memory, I only use
8/24 samples, which I have saved in this repo as an
`minfi::RGChannelSet` object.

    library(plmec)
    library(minfi)      # for normalization
    library(wateRmelon) # for normalization
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

Ideally, your data should be normalized in the same manner as the
training data used to develop the ethnicity-predictive model. If IDATs
are supplied, you can apply both
[noob](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3627582/) and
[BMIQ](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3546795/)
normalization. If only methylated and unmethylated data matrices are
available, you can apply just BMIQ. If neither are available, then you
can still run the inference but be wary dataset-specific effects may
affect accuracy.

To apply normalization, run `minfi::preprocessNoob()` and then
`wateRmelon::BMIQ()`:

    pl_noob <- preprocessNoob(pl_rgset)
    pl_bmiq <- BMIQ(pl_noob)

combine the methylation data with the 65 snp probe data (59 SNPs, if
using EPIC).

    pl_snps <- getSnpBeta(pl_rgset)
    pl_dat <- rbind(pl_bmiq, pl_snps)
    dim(pl_dat) # 485577     8

    ## [1] 485577      8

### Infer ethnicity

The reason we added the snp data onto the betas matrix was because a
subset of those are used to predict ethnicity. The input data needs to
contain all 1862 features in the final model. We can check this our data
for these features with the `pl_ethnicity_features` vector.

    all(pl_ethnicity_features %in% rownames(pl_dat))

    ## [1] TRUE

You don't need to subset to these 1862 features before running
`pl_ethnicity_infer()` to obtain ethnicity calls:

    dim(pl_dat)

    ## [1] 485577      8

    results <- pl_infer_ethnicity(pl_dat)

    ## [1] "1862 of 1862 predictors present."

    print(results, row.names = F)

    ##                     Sample_ID Predicted_ethnicity_nothresh
    ##  GSM1944959_9376561070_R05C01                        Asian
    ##  GSM1944960_9376561070_R06C01                    Caucasian
    ##  GSM1944961_9376561070_R01C02                        Asian
    ##  GSM1944962_9376561070_R02C02                    Caucasian
    ##  GSM1944963_9376561070_R03C02                    Caucasian
    ##  GSM1944964_9376561070_R04C02                    Caucasian
    ##  GSM1944965_9376561070_R05C02                    Caucasian
    ##  GSM1944966_9376561070_R06C02                    Caucasian
    ##  Predicted_ethnicity Prob_African   Prob_Asian Prob_Caucasian Highest_Prob
    ##                Asian 0.0108744464 0.9608744853     0.02825107    0.9608745
    ##            Caucasian 0.0145143895 0.1571743610     0.82831125    0.8283112
    ##                Asian 0.0202528838 0.8994892679     0.08025785    0.8994893
    ##            Caucasian 0.0007565667 0.0007720338     0.99847140    0.9984714
    ##            Caucasian 0.0018592489 0.0022457704     0.99589498    0.9958950
    ##            Caucasian 0.0072757093 0.0126948036     0.98002949    0.9800295
    ##            Caucasian 0.0019096988 0.0021660987     0.99592420    0.9959242
    ##            Caucasian 0.0009336147 0.0015319691     0.99753442    0.9975344

    qplot(data = results, x = Prob_Caucasian, y = Prob_African, 
         col = Predicted_ethnicity, xlim = c(0,1), ylim = c(0,1))

![](README_files/figure-markdown_strict/unnamed-chunk-5-1.png)

    qplot(data = results, x = Prob_Caucasian, y = Prob_Asian, 
         col = Predicted_ethnicity, xlim = c(0,1), ylim = c(0,1))

![](README_files/figure-markdown_strict/unnamed-chunk-5-2.png)

\*For the entire dataset (not just the subset shown here), 22/24 were
predicted Caucasian and 2/24 Asian.

We can't compare this to self-reported ethnicity as it is unavailable.
But we know these samples were collected in Sydney, Australia, and are
therefore likely mostly European with some Asian ancestries.

    table(results$Predicted_ethnicity)

    ## 
    ##     Asian Caucasian 
    ##         2         6
