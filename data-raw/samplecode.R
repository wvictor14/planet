library(mixOmics)
library(here)
library(dplyr)
library(janitor)
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
predict.filt$class
predict.filt$MajorityVote$max.dist

library(tibble)
results <- tibble(sample_id = rownames(predict.filt$predict)) %>%
  bind_cols(as_tibble(predict.filt$predict))  %>%
  mutate(pl_pe_class = predict.filt$class$max.dist[,'comp1']) %>%
  janitor::clean_names() %>%
  rename(pl_pe_class_eope_dim1 = eope_dim1,
         pl_pe_class_npe_dim1 = non_pe_preterm_dim1) 
results

object.size(mod) %>% print(unit = 'Mb')
