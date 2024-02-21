
# planet <img src="man/figures/logo.png" align="right" height = "139" />

<!-- badges: start -->

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.4321633.svg)](https://doi.org/10.5281/zenodo.4321633)
[![](https://img.shields.io/github/last-commit/GuangchuangYu/badger.svg)](https://github.com/GuangchuangYu/badger/commits/main)
[![R build
status](https://github.com/wvictor14/planet/workflows/R-CMD-check/badge.svg)](https://github.com/wvictor14/planet/actions)
[![Lifecycle:
stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://www.tidyverse.org/lifecycle/#stable)
[![R-CMD-check](https://github.com/wvictor14/planet/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/wvictor14/planet/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

`planet` is an R package for inferring **ethnicity** (1), **gestational
age** (2), and **cell composition** (3) from placental DNA methylation
data.

See full documentation at <https://victor.rbind.io/planet>

### Installation

Latest Bioconductor release

``` r
if(!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
BiocManager::install("planet")
```

Or the development version of `planet`:

``` r
devtools::install_github('wvictor14/planet')
```

### Usage

See [vignettes](https://victor.rbind.io/planet/articles) for more
detailed usage.

#### Example Data

All functions in this package take as input DNAm data the 450k and EPIC
DNAm microarray. For best performance I suggest providing unfiltered
data normalized with noob and BMIQ. A processed example dataset,
`plBetas`, is provided to show the format that this data should be in.
The output of all `planet` functions is a `data.frame`.

A quick example of each major function is illustrated with this example
data:

``` r
library(minfi)
library(planet)

#load example data
data(plBetas)
data(plPhenoData) # sample information
```

#### Predict Ethnicity

``` r
predictEthnicity(plBetas) %>%
  head()
#> 1860 of 1860 predictors present.
#> # A tibble: 6 × 7
#>   Sample_ID  Predicted_ethnicity_nothresh Predicted_ethnicity
#>   <chr>      <chr>                        <chr>              
#> 1 GSM1944936 Caucasian                    Caucasian          
#> 2 GSM1944939 Caucasian                    Caucasian          
#> 3 GSM1944942 Caucasian                    Caucasian          
#> 4 GSM1944944 Caucasian                    Caucasian          
#> 5 GSM1944946 Caucasian                    Caucasian          
#> 6 GSM1944948 Caucasian                    Caucasian          
#> # ℹ 4 more variables: Prob_African <dbl>, Prob_Asian <dbl>,
#> #   Prob_Caucasian <dbl>, Highest_Prob <dbl>
```

#### Predict Gestational Age

There are 3 gestational age clocks for placental DNA methylation data
from Lee Y. et al. 2019 (2). To use a specific one, we can use the
`type` argument in `predictAge`:

``` r
predictAge(plBetas, type = 'RPC') %>%
  head()
#> 558 of 558 predictors present.
#> [1] 38.46528 33.09680 34.32520 35.50937 37.63910 36.77051
```

#### Predict Cell Composition

Reference data to infer cell composition on placental villi DNAm samples
(3) can be used with cell deconvolution from minfi or EpiDISH. These are
provided in this package as `plCellCpGsThird` and `plCellCpGsFirst` for
third trimester (term) and first trimester samples, respectively.

``` r
data('plCellCpGsThird')

minfi:::projectCellType(
  
  # subset your data to cell cpgs
  plBetas[rownames(plCellCpGsThird),], 
  
  # input the reference cpg matrix
  plCellCpGsThird,
  
  lessThanOne = FALSE) %>%
  
  head()
#>            Trophoblasts    Stromal      Hofbauer Endothelial
#> GSM1944936    0.1091279 0.04891919  0.000000e+00  0.08983998
#> GSM1944939    0.2299918 0.00000000 -1.806592e-19  0.07888007
#> GSM1944942    0.1934287 0.03483540  0.000000e+00  0.09260353
#> GSM1944944    0.2239896 0.06249135  1.608645e-03  0.11040693
#> GSM1944946    0.1894152 0.07935955  0.000000e+00  0.10587439
#> GSM1944948    0.2045124 0.07657717  0.000000e+00  0.09871149
#>                  nRBC Syncytiotrophoblast
#> GSM1944936 0.05294062           0.6979477
#> GSM1944939 0.03374149           0.6377822
#> GSM1944942 0.02929310           0.6350506
#> GSM1944944 0.04447951           0.5467642
#> GSM1944946 0.05407587           0.6022329
#> GSM1944948 0.02269798           0.6085825
```

### References

1.  [**Yuan V**, Price EM, Del Gobbo G, Mostafavi S, Cox B, Binder AM,
    et al. Accurate ethnicity prediction from placental DNA methylation
    data. Epigenetics & Chromatin. 2019 Aug
    9;12(1):51.](https://epigeneticsandchromatin.biomedcentral.com/articles/10.1186/s13072-019-0296-3)

2.  [Lee Y, Choufani S, Weksberg R, Wilson SL, **Yuan V**, et
    al. Placental epigenetic clocks: estimating gestational age using
    placental DNA methylation levels. Aging (Albany NY).
    2019;11(12):4238–4253.
    doi:10.18632/aging.102049](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6628997/)

3.  [**Yuan V**, Hui D, Yin Y, Peñaherrera MS, Beristain AG, Robinson
    WP. Cell-specific characterization of the placental methylome. BMC
    Genomics. 2021 Jan
    6;22(1):6.](https://bmcgenomics.biomedcentral.com/articles/10.1186/s12864-020-07186-6)
