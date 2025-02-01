
# planet <img src="man/figures/logo.png" align="right" height = "100px"  style="float:right; height:100px;"/>

<!-- badges: start -->

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.4321633.svg)](https://doi.org/10.5281/zenodo.4321633)
[![](https://img.shields.io/github/last-commit/GuangchuangYu/badger.svg)](https://github.com/GuangchuangYu/badger/commits/main)
[![Lifecycle:
stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://www.tidyverse.org/lifecycle/#stable)
[![R-CMD-check](https://github.com/wvictor14/planet/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/wvictor14/planet/actions/workflows/R-CMD-check.yaml)

[![Bioc release
status](http://www.bioconductor.org/shields/build/release/bioc/planet.svg)](https://bioconductor.org/checkResults/release/bioc-LATEST/planet)
[![Bioc devel
status](http://www.bioconductor.org/shields/build/devel/bioc/planet.svg)](https://bioconductor.org/checkResults/devel/bioc-LATEST/planet)
[![Bioc downloads
rank](https://bioconductor.org/shields/downloads/release/planet.svg)](http://bioconductor.org/packages/stats/bioc/planet/)
[![Bioc
history](https://bioconductor.org/shields/years-in-bioc/planet.svg)](https://bioconductor.org/packages/release/bioc/html/planet.html#since)
[![Bioc last
commit](https://bioconductor.org/shields/lastcommit/devel/bioc/planet.svg)](http://bioconductor.org/checkResults/devel/bioc-LATEST/planet/)
[![Bioc
dependencies](https://bioconductor.org/shields/dependencies/release/planet.svg)](https://bioconductor.org/packages/release/bioc/html/planet.html#since)
<!-- badges: end -->

`planet` is an R package for inferring **ethnicity** [(1)](#references),
**gestational age** [(2)](#references), **cell composition**
[(3)](#references), and disease status (preeclampsia/inflammation)
[(4)](#references), from placental DNA methylation data.

See full documentation at
[victoryuan.com/planet](https://victoryuan.com/planet)

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
#>   Sample_ID  Predicted_ethnicity_n…¹ Predicted_ethnicity Prob_African Prob_Asian
#>   <chr>      <chr>                   <chr>                      <dbl>      <dbl>
#> 1 GSM1944936 Caucasian               Caucasian               0.00331    0.0164  
#> 2 GSM1944939 Caucasian               Caucasian               0.000772   0.000514
#> 3 GSM1944942 Caucasian               Caucasian               0.000806   0.000699
#> 4 GSM1944944 Caucasian               Caucasian               0.000883   0.000792
#> 5 GSM1944946 Caucasian               Caucasian               0.000885   0.00130 
#> 6 GSM1944948 Caucasian               Caucasian               0.000852   0.000973
#> # ℹ abbreviated name: ¹​Predicted_ethnicity_nothresh
#> # ℹ 2 more variables: Prob_Caucasian <dbl>, Highest_Prob <dbl>
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
#>            Trophoblasts    Stromal     Hofbauer Endothelial       nRBC
#> GSM1944936    0.1091279 0.04891919 0.000000e+00  0.08983998 0.05294062
#> GSM1944939    0.2299918 0.00000000 6.680983e-20  0.07888007 0.03374149
#> GSM1944942    0.1934287 0.03483540 0.000000e+00  0.09260353 0.02929310
#> GSM1944944    0.2239896 0.06249135 1.608645e-03  0.11040693 0.04447951
#> GSM1944946    0.1894152 0.07935955 0.000000e+00  0.10587439 0.05407587
#> GSM1944948    0.2045124 0.07657717 0.000000e+00  0.09871149 0.02269798
#>            Syncytiotrophoblast
#> GSM1944936           0.6979477
#> GSM1944939           0.6377822
#> GSM1944942           0.6350506
#> GSM1944944           0.5467642
#> GSM1944946           0.6022329
#> GSM1944948           0.6085825
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

4.  [**Fernández-Boyano I**, A.M. Inkster, **V. Yuan**, W.P. Robinson
    medRxiv 2023
    May](https://www.medrxiv.org/content/10.1101/2023.05.17.23290125v1)
