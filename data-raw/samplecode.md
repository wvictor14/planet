samplecode
================

``` r
library(mixOmics)
```

    ## Loading required package: MASS

    ## Loading required package: lattice

    ## Loading required package: ggplot2

    ## 
    ## Loaded mixOmics 6.20.0
    ## Thank you for using mixOmics!
    ## Tutorials: http://mixomics.org
    ## Bookdown vignette: https://mixomicsteam.github.io/Bookdown
    ## Questions, issues: Follow the prompts at http://mixomics.org/contact-us
    ## Cite us:  citation('mixOmics')

``` r
library(here)
```

    ## here() starts at C:/Users/victo/Documents/Projects/planet

``` r
library(dplyr)
```

    ## 
    ## Attaching package: 'dplyr'

    ## The following object is masked from 'package:MASS':
    ## 
    ##     select

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

``` r
library(janitor)
```

    ## 
    ## Attaching package: 'janitor'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     chisq.test, fisher.test

``` r
x_train <- readRDS(here('data-raw', 'x_train.rds'))
y_train <- readRDS(here('data-raw', 'y_train.rds'))
x_test <- readRDS(here('data-raw', 'x_test.rds'))

mod <- mixOmics::splsda(x_train,
                        y_train,
                        ncomp = 1,
                        keepX = 45)

predict.filt <- predict(mod,
                        x_test,
                        dist = "max.dist")

predict.filt$predict
```

    ## , , dim1
    ## 
    ##                   EOPE Non-PE Preterm
    ## GSM2589533  0.69041055    0.309589448
    ## GSM2589535  0.95457620    0.045423796
    ## GSM2589536  2.24934329   -1.249343288
    ## GSM2589538  1.05058250   -0.050582502
    ## GSM2589540  0.05202091    0.947979092
    ## GSM2589541  0.70699815    0.293001852
    ## GSM2589545  0.78141262    0.218587384
    ## GSM2589546  1.19485533   -0.194855332
    ## GSM2589549  1.04452007   -0.044520067
    ## GSM2589552  0.32835635    0.671643653
    ## GSM2589553  0.47114290    0.528857096
    ## GSM2589554  1.17310529   -0.173105286
    ## GSM2589556  0.13897930    0.861020700
    ## GSM2589558  0.46352289    0.536477110
    ## GSM2589559  1.90848557   -0.908485568
    ## GSM2589560  0.99149291    0.008507093
    ## GSM2589561  0.92952888    0.070471116
    ## GSM2589562  1.12122675   -0.121226748
    ## GSM2589563  2.00660066   -1.006600658
    ## GSM2589566 -0.15601569    1.156015695
    ## GSM2589573  0.86386245    0.136137554
    ## GSM2589574  0.72244272    0.277557277
    ## GSM2589575  0.72538879    0.274611208
    ## GSM2589577  0.85172485    0.148275151
    ## GSM2589578  0.85088966    0.149110341
    ## GSM3578095  2.07347556   -1.073475562
    ## GSM3578100  0.80117080    0.198829203
    ## GSM3578102  1.26688974   -0.266889738
    ## GSM3578104  1.08929137   -0.089291366
    ## GSM3578105  1.29469144   -0.294691441
    ## GSM3578107  1.47663018   -0.476630181
    ## GSM3578108  1.86441779   -0.864417788
    ## GSM3578109  1.45521504   -0.455215043
    ## GSM3578110  1.66409486   -0.664094863
    ## GSM3578111  1.10200610   -0.102006105
    ## GSM3578112  1.24324581   -0.243245808
    ## GSM3578113  1.55369531   -0.553695311
    ## GSM3578114  0.78000237    0.219997632
    ## GSM3578115  1.62028493   -0.620284927
    ## GSM3578116  1.26368419   -0.263684193
    ## GSM3578117  1.54891812   -0.548918125
    ## GSM3578118  1.12229355   -0.122293552
    ## GSM3578119  0.89729728    0.102702719
    ## GSM3578121  1.13809091   -0.138090907
    ## GSM3578123  0.82758325    0.172416751
    ## GSM3578124  1.52581757   -0.525817572
    ## GSM3578125  0.94933674    0.050663255
    ## GSM3578127  0.92783631    0.072163692

``` r
predict.filt$class
```

    ## $max.dist
    ##            comp1           
    ## GSM2589533 "EOPE"          
    ## GSM2589535 "EOPE"          
    ## GSM2589536 "EOPE"          
    ## GSM2589538 "EOPE"          
    ## GSM2589540 "Non-PE Preterm"
    ## GSM2589541 "EOPE"          
    ## GSM2589545 "EOPE"          
    ## GSM2589546 "EOPE"          
    ## GSM2589549 "EOPE"          
    ## GSM2589552 "Non-PE Preterm"
    ## GSM2589553 "Non-PE Preterm"
    ## GSM2589554 "EOPE"          
    ## GSM2589556 "Non-PE Preterm"
    ## GSM2589558 "Non-PE Preterm"
    ## GSM2589559 "EOPE"          
    ## GSM2589560 "EOPE"          
    ## GSM2589561 "EOPE"          
    ## GSM2589562 "EOPE"          
    ## GSM2589563 "EOPE"          
    ## GSM2589566 "Non-PE Preterm"
    ## GSM2589573 "EOPE"          
    ## GSM2589574 "EOPE"          
    ## GSM2589575 "EOPE"          
    ## GSM2589577 "EOPE"          
    ## GSM2589578 "EOPE"          
    ## GSM3578095 "EOPE"          
    ## GSM3578100 "EOPE"          
    ## GSM3578102 "EOPE"          
    ## GSM3578104 "EOPE"          
    ## GSM3578105 "EOPE"          
    ## GSM3578107 "EOPE"          
    ## GSM3578108 "EOPE"          
    ## GSM3578109 "EOPE"          
    ## GSM3578110 "EOPE"          
    ## GSM3578111 "EOPE"          
    ## GSM3578112 "EOPE"          
    ## GSM3578113 "EOPE"          
    ## GSM3578114 "EOPE"          
    ## GSM3578115 "EOPE"          
    ## GSM3578116 "EOPE"          
    ## GSM3578117 "EOPE"          
    ## GSM3578118 "EOPE"          
    ## GSM3578119 "EOPE"          
    ## GSM3578121 "EOPE"          
    ## GSM3578123 "EOPE"          
    ## GSM3578124 "EOPE"          
    ## GSM3578125 "EOPE"          
    ## GSM3578127 "EOPE"

``` r
predict.filt$MajorityVote$max.dist
```

    ##            comp1           
    ## GSM2589533 "EOPE"          
    ## GSM2589535 "EOPE"          
    ## GSM2589536 "EOPE"          
    ## GSM2589538 "EOPE"          
    ## GSM2589540 "Non-PE Preterm"
    ## GSM2589541 "EOPE"          
    ## GSM2589545 "EOPE"          
    ## GSM2589546 "EOPE"          
    ## GSM2589549 "EOPE"          
    ## GSM2589552 "Non-PE Preterm"
    ## GSM2589553 "Non-PE Preterm"
    ## GSM2589554 "EOPE"          
    ## GSM2589556 "Non-PE Preterm"
    ## GSM2589558 "Non-PE Preterm"
    ## GSM2589559 "EOPE"          
    ## GSM2589560 "EOPE"          
    ## GSM2589561 "EOPE"          
    ## GSM2589562 "EOPE"          
    ## GSM2589563 "EOPE"          
    ## GSM2589566 "Non-PE Preterm"
    ## GSM2589573 "EOPE"          
    ## GSM2589574 "EOPE"          
    ## GSM2589575 "EOPE"          
    ## GSM2589577 "EOPE"          
    ## GSM2589578 "EOPE"          
    ## GSM3578095 "EOPE"          
    ## GSM3578100 "EOPE"          
    ## GSM3578102 "EOPE"          
    ## GSM3578104 "EOPE"          
    ## GSM3578105 "EOPE"          
    ## GSM3578107 "EOPE"          
    ## GSM3578108 "EOPE"          
    ## GSM3578109 "EOPE"          
    ## GSM3578110 "EOPE"          
    ## GSM3578111 "EOPE"          
    ## GSM3578112 "EOPE"          
    ## GSM3578113 "EOPE"          
    ## GSM3578114 "EOPE"          
    ## GSM3578115 "EOPE"          
    ## GSM3578116 "EOPE"          
    ## GSM3578117 "EOPE"          
    ## GSM3578118 "EOPE"          
    ## GSM3578119 "EOPE"          
    ## GSM3578121 "EOPE"          
    ## GSM3578123 "EOPE"          
    ## GSM3578124 "EOPE"          
    ## GSM3578125 "EOPE"          
    ## GSM3578127 "EOPE"

``` r
library(tibble)
results <- tibble(sample_id = rownames(predict.filt$predict)) %>%
  bind_cols(as_tibble(predict.filt$predict))  %>%
  mutate(pl_pe_class = predict.filt$class$max.dist[,'comp1']) %>%
  janitor::clean_names() %>%
  rename(pl_pe_class_eope_dim1 = eope_dim1,
         pl_pe_class_npe_dim1 = non_pe_preterm_dim1) 
results
```

    ## # A tibble: 48 × 4
    ##    sample_id  pl_pe_class_eope_dim1 pl_pe_class_npe_dim1 pl_pe_class   
    ##    <chr>                      <dbl>                <dbl> <chr>         
    ##  1 GSM2589533                0.690                0.310  EOPE          
    ##  2 GSM2589535                0.955                0.0454 EOPE          
    ##  3 GSM2589536                2.25                -1.25   EOPE          
    ##  4 GSM2589538                1.05                -0.0506 EOPE          
    ##  5 GSM2589540                0.0520               0.948  Non-PE Preterm
    ##  6 GSM2589541                0.707                0.293  EOPE          
    ##  7 GSM2589545                0.781                0.219  EOPE          
    ##  8 GSM2589546                1.19                -0.195  EOPE          
    ##  9 GSM2589549                1.04                -0.0445 EOPE          
    ## 10 GSM2589552                0.328                0.672  Non-PE Preterm
    ## # … with 38 more rows

``` r
object.size(mod) %>% print(unit = 'Mb')
```

    ## 609.3 Mb
