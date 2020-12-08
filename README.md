
# planet

[![DOI](https://zenodo.org/badge/157781369.svg)](https://zenodo.org/badge/latestdoi/157781369)

`planet` is an R package for inferring **ethnicity**, **gestational
age**, and **cell composition** from placental DNA methylation data
\[^1\](\#references)\[^2\](\#references)\[^3\](\#references).

See full documentation at <https://wvictor14.github.io/planet/>

-   [Installation](#installation)

-   [Usage](#usage)

    -   [Example Data](#example-data)
    -   [Infer Ethnicity](#infer-ethnicity)
    -   [Infer Gestational Age](#infer-gestational-age)
    -   [Infer Cell Composition](#infer-cell-composition)

-   [References](#references---references-)

## Installation

You can install from this github repo with:

``` r
devtools::install_github('wvictor14/planet')
```

## Quick Usage

### Example Data

All functions in this package take as input DNAm data. An example
dataset, `pl_betas`, is provided to show the format that this data
should be in. The output of all `planet` functions is a `data.frame`.

A quick example:

``` r
library(minfi)
library(tidyverse)
library(planet)

#load example data
data(pl_betas)
data(pl_pDat) # sample information
```

#### Infer Ethnicity

``` r
pl_infer_ethnicity(pl_betas)
#> [1] "1860 of 1860 predictors present."
#> # A tibble: 24 x 7
#>    Sample_ID Predicted_ethni~ Predicted_ethni~ Prob_African Prob_Asian
#>    <chr>     <chr>            <chr>                   <dbl>      <dbl>
#>  1 GSM19449~ Caucasian        Caucasian            0.00331    0.0164  
#>  2 GSM19449~ Caucasian        Caucasian            0.000772   0.000514
#>  3 GSM19449~ Caucasian        Caucasian            0.000806   0.000699
#>  4 GSM19449~ Caucasian        Caucasian            0.000883   0.000792
#>  5 GSM19449~ Caucasian        Caucasian            0.000885   0.00130 
#>  6 GSM19449~ Caucasian        Caucasian            0.000852   0.000973
#>  7 GSM19449~ Caucasian        Caucasian            0.000902   0.00176 
#>  8 GSM19449~ Caucasian        Caucasian            0.00174    0.00223 
#>  9 GSM19449~ Caucasian        Caucasian            0.000962   0.00231 
#> 10 GSM19449~ Caucasian        Caucasian            0.00287    0.00356 
#> # ... with 14 more rows, and 2 more variables: Prob_Caucasian <dbl>,
#> #   Highest_Prob <dbl>
```

#### Infer Gestational Age

There are 3 gestational age clocks for placental DNA methylation data
from \[Lee Y. et al. 2019 \[^2\](\#references):

1.  Robust Placental Clock (RPC)
2.  Control Placental Clock (CPC)
3.  Refined Robust Placental Clock (RRPC)

To use a specific one, we can use the `type` argument in `pl_infer_age`:

``` r
pl_infer_age(pl_betas, type = 'RPC')
#> [1] "558 of 558 predictors present."
#>  [1] 38.46528 33.09680 34.32520 35.50937 37.63910 36.77051 38.16438 35.87109
#>  [9] 40.15282 39.68453 39.70126 39.88097 39.69894 38.70228 40.46110 39.94836
#> [17] 39.34447 39.17964 38.39203 38.90091 38.35389 39.57497 39.71251 38.23313
```

### Infer Cell Composition

To infer cell composition on placental villi DNAm samples, we can use
the reference cpgs identified in \[^3\](\#references). These are
provided in this package as `pl_cell_cpgs_third` and
`pl_cell_cpgs_first` for third trimester (term) and first trimester
samples, respectively.

``` r
data('pl_cell_cpgs_third')
```

After our reference cpg data is loaded, we can estimate cell composition
by applying either the Constrained Projection approach implemented by
the R packages `minfi` or `EpiDISH`, or a non-constrained approach by
`EpiDish`.

Below I show how to apply deconvolution using `minfi`:

``` r
minfi:::projectCellType(
  
  # subset your data to cell cpgs
  pl_betas[rownames(pl_cell_cpgs_third),], 
  
  # input the reference cpg matrix
  pl_cell_cpgs_third,
  
  lessThanOne = FALSE)
#>            Trophoblasts    Stromal      Hofbauer Endothelial       nRBC
#> GSM1944936   0.10912791 0.04891919  0.000000e+00  0.08983998 0.05294062
#> GSM1944939   0.22999177 0.00000000 -1.806592e-19  0.07888007 0.03374149
#> GSM1944942   0.19342866 0.03483540  0.000000e+00  0.09260353 0.02929310
#> GSM1944944   0.22398964 0.06249135  1.608645e-03  0.11040693 0.04447951
#> GSM1944946   0.18941519 0.07935955  0.000000e+00  0.10587439 0.05407587
#> GSM1944948   0.20451244 0.07657717  0.000000e+00  0.09871149 0.02269798
#> GSM1944949   0.14137082 0.04052886 -1.734723e-18  0.07104675 0.04844821
#> GSM1944950   0.09041405 0.05403395  0.000000e+00  0.08599976 0.03292041
#> GSM1944951   0.02453726 0.09480165  0.000000e+00  0.08224892 0.02811272
#> GSM1944952   0.14319910 0.08987292  1.650890e-02  0.08158034 0.04056079
#> GSM1944953   0.20069357 0.09189389  0.000000e+00  0.11088828 0.05554471
#> GSM1944954   0.24492455 0.09551381  8.551038e-06  0.09558598 0.03519312
#> GSM1944955   0.19093209 0.07728719  3.265148e-03  0.11260508 0.05682111
#> GSM1944956   0.17337166 0.09842763  0.000000e+00  0.12279989 0.03565655
#> GSM1944957   0.15127704 0.07934725  0.000000e+00  0.09614832 0.03678579
#> GSM1944958   0.08555845 0.11611689  9.708612e-03  0.08682468 0.05888290
#> GSM1944959   0.17999673 0.12913852  8.673617e-19  0.12087549 0.04388099
#> GSM1944960   0.13084579 0.10356119  0.000000e+00  0.09795318 0.03517636
#> GSM1944961   0.24055158 0.07167903  0.000000e+00  0.13002816 0.02868567
#> GSM1944962   0.22849186 0.01999528  9.076153e-03  0.10098524 0.03515156
#> GSM1944963   0.20752072 0.12765719  6.808943e-03  0.13704769 0.03779314
#> GSM1944964   0.02937035 0.09247878  0.000000e+00  0.09778279 0.05986503
#> GSM1944965   0.01639166 0.10901163  2.517471e-02  0.06414551 0.03813293
#> GSM1944966   0.10572045 0.04972575  0.000000e+00  0.07686261 0.02219202
#>            Syncytiotrophoblast
#> GSM1944936           0.6979477
#> GSM1944939           0.6377822
#> GSM1944942           0.6350506
#> GSM1944944           0.5467642
#> GSM1944946           0.6022329
#> GSM1944948           0.6085825
#> GSM1944949           0.7065337
#> GSM1944950           0.7494739
#> GSM1944951           0.8098272
#> GSM1944952           0.6334274
#> GSM1944953           0.5643498
#> GSM1944954           0.5492940
#> GSM1944955           0.5725059
#> GSM1944956           0.5883822
#> GSM1944957           0.6462834
#> GSM1944958           0.6803711
#> GSM1944959           0.5509971
#> GSM1944960           0.6477206
#> GSM1944961           0.5148841
#> GSM1944962           0.5932219
#> GSM1944963           0.5186078
#> GSM1944964           0.7645366
#> GSM1944965           0.7834136
#> GSM1944966           0.7666303
```

## References

1.  [**Yuan V**, Price EM, Del Gobbo G, Mostafavi S, Cox B, Binder AM,
    et al. Accurate ethnicity prediction from placental DNA methylation
    data. Epigenetics & Chromatin. 2019 Aug
    9;12(1):51.](https://epigeneticsandchromatin.biomedcentral.com/articles/10.1186/s13072-019-0296-3)

2.  [Lee Y, Choufani S, Weksberg R, Wilson SL, **Yuan V**, et
    al. Placental epigenetic clocks: estimating gestational age using
    placental DNA methylation levels. Aging (Albany NY).
    2019;11(12):4238–4253.
    doi:10.18632/aging.102049](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6628997/)

3.  [Victor Yuan, Desmond Hui, Yifan Yin et al. Cell-specific
    Characterization of the Placental Methylome, 29 October 2020,
    PREPRINT (Version 3) available at Research
    Square](https://www.researchsquare.com/article/rs-38223/v3)
