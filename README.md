
planet :earth\_americas:
========================

`planet` is an R package for inferring ethnicity from placental DNA methylation microarray data \[1\].

Installation
------------

You can install from this github repo with:

``` r
library(devtools)
install_github('wvictor14/planet')
```

Usage
-----

### Example Data

For demonstration purposes, I downloaded a [placental DNAm dataset from GEO](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE75196) \[2\], which contains samples collected in an Australian population. To save on memory, I only use 8/24 samples, which I have saved in this repo as a `minfi::RGChannelSet` object.

``` r
library(planet)
library(minfi)      # for normalization
library(wateRmelon) # for normalization
library(ggplot2)    

#load example data
data(pl_rgset)
pl_rgset # 8 samples
#> class: RGChannelSet 
#> dim: 622399 8 
#> metadata(0):
#> assays(2): Green Red
#> rownames(622399): 10600313 10600322 ... 74810490 74810492
#> rowData names(0):
#> colnames(8): GSM1944959_9376561070_R05C01
#>   GSM1944960_9376561070_R06C01 ... GSM1944965_9376561070_R05C02
#>   GSM1944966_9376561070_R06C02
#> colData names(0):
#> Annotation
#>   array: IlluminaHumanMethylation450k
#>   annotation: ilmn12.hg19
```

### Preprocessing data

I recommend to normalize your data using the same methods I used to normalize the training data. Performance on datasets normalized by other methods has not been evaluated yet.

If IDATs are supplied, you can apply both `noob`[\[3\]](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3627582/) and `BMIQ`[\[4\]](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3546795/) normalization. If only methylated and unmethylated data matrices are available, you can apply just `BMIQ`.

To apply normalization, run `minfi::preprocessNoob()` and then `wateRmelon::BMIQ()`:

``` r
pl_noob <- preprocessNoob(pl_rgset)
pl_bmiq <- BMIQ(pl_noob)
```

Note that `preprocessNoob` will drop SNP probes automatically. Because we need these to infer ethnicity, we need to combine the methylation data with the 65 snp probe data (59 SNPs, if using EPIC):

``` r
pl_snps <- getSnpBeta(pl_rgset)
pl_dat <- rbind(pl_bmiq, pl_snps)
dim(pl_dat) # 485577     8
#> [1] 485577      8
```

### Infer ethnicity

The input data needs to contain all 1860 features in the final model. We can check our data for these features with the `pl_ethnicity_features` vector:

``` r
all(pl_ethnicity_features %in% rownames(pl_dat))
#> [1] TRUE
```

To obtain ethnicity calls, you can supply the full DNA methylation data to `pl_ethnicity_infer()`, as long as all 1860 features are present.

``` r
dim(pl_dat)
#> [1] 485577      8
results <- pl_infer_ethnicity(pl_dat)
#> [1] "1860 of 1860 predictors present."
print(results, row.names = F)
#>                     Sample_ID Predicted_ethnicity_nothresh
#>  GSM1944959_9376561070_R05C01                        Asian
#>  GSM1944960_9376561070_R06C01                    Caucasian
#>  GSM1944961_9376561070_R01C02                        Asian
#>  GSM1944962_9376561070_R02C02                    Caucasian
#>  GSM1944963_9376561070_R03C02                    Caucasian
#>  GSM1944964_9376561070_R04C02                    Caucasian
#>  GSM1944965_9376561070_R05C02                    Caucasian
#>  GSM1944966_9376561070_R06C02                    Caucasian
#>  Predicted_ethnicity Prob_African   Prob_Asian Prob_Caucasian Highest_Prob
#>                Asian 0.0127138127 0.9552363704     0.03204982    0.9552364
#>            Caucasian 0.0118014134 0.1172642378     0.87093435    0.8709343
#>                Asian 0.0202598482 0.8998896168     0.07985053    0.8998896
#>            Caucasian 0.0006788990 0.0006991062     0.99862199    0.9986220
#>            Caucasian 0.0018404533 0.0023112871     0.99584826    0.9958483
#>            Caucasian 0.0072402825 0.0121289538     0.98063076    0.9806308
#>            Caucasian 0.0016560781 0.0017611636     0.99658276    0.9965828
#>            Caucasian 0.0009574405 0.0015229362     0.99751962    0.9975196
```

`pl_infer_ethnicity` returns probabilities corresponding to each ethnicity for each sample (e.g `Prob_Caucasian`, `Prob_African`, `Prob_Asian`). A final classification is determined in two ways:

1.  `Predicted_ethnicity_nothresh` - returns a classification corresponding to the highest class-specific probability.

2.  `Predicted_ethnicity` - if the highest class-specific probability is below `0.75`, then the the sample is assigned an `Amibiguous` label. This threshold can be adjusted with the `threshold` argument. Samples with this label might require special attention in downstream analyses.

``` r
qplot(data = results, x = Prob_Caucasian, y = Prob_African, 
     col = Predicted_ethnicity, xlim = c(0,1), ylim = c(0,1))
```

<img src="man/figures/README-plot_results-1.png" width="100%" />

``` r
qplot(data = results, x = Prob_Caucasian, y = Prob_Asian, 
     col = Predicted_ethnicity, xlim = c(0,1), ylim = c(0,1))
```

<img src="man/figures/README-plot_results-2.png" width="100%" />

\*For the entire dataset (not just the subset shown here), 22/24 were predicted Caucasian and 2/24 Asian.

We can't compare this to self-reported ethnicity as it is unavailable. But we know these samples were collected in Sydney, Australia, and are therefore likely mostly European with some East Asian ancestries.

``` r
table(results$Predicted_ethnicity)
#> 
#>     Asian Caucasian 
#>         2         6
```

### Adjustment in differential methylation analysis

Because 'Ambiguous' samples might have different mixtures of ancestries, it might be inadequate to adjust for them as one group in an analysis of admixed populations (e.g. 50/50 Asian/African should not be considered the same group as 50/50 Caucasian/African). One solution would be to simply remove these samples. Another would be to adjust for the raw probabilities-in this case, use only two of the three probabilities, since the third will be redundant (probabilities sum to 1). If sample numbers are large enough in each group, stratifying downstream analyses by ethnicity might also be a valid option.

References
----------

\[1\] Yuan V, Price M, Del Gobbo G, Mostafavi S, Cox B, Binder AM, Michels KB, Marsit C, Robinson W: Inferring population structure from placental DNA methylation studies. *In prep.*

\[2\] Yeung KR, Chiu CL, Pidsley R, Makris A, Hennessy A, Lind JM: DNA methylation profiles in preeclampsia and healthy control placentas. Am J Physiol Circ Physiol 2016, 310:H1295–H1303.

\[3\] Triche TJ, Weisenberger DJ, Van Den Berg D, Laird PW, Siegmund KD, Siegmund KD: Low-level processing of Illumina Infinium DNA Methylation BeadArrays. Nucleic Acids Res 2013, 41:e90.

\[4\] Teschendorff AE, Marabita F, Lechner M, Bartlett T, Tegner J, Gomez-Cabrero D, Beck S: A beta-mixture quantile normalization method for correcting probe design bias in Illumina Infinium 450 k DNA methylation data. Bioinformatics 2013, 29:189–96.
