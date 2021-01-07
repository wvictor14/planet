# Execute the code from the vignette
knitr::knit(here::here("inst", "script", "cell_composition.Rmd.orig"), 
            output = here::here("vignettes", "cell_composition.Rmd"))

knitr::knit(here::here("inst", "script", "ethnicity.Rmd.orig"), 
            output = here::here("vignettes", "ethnicity.Rmd"))

knitr::knit(here::here("inst", "script", "gestational_age.Rmd.orig"), 
            output = here::here("vignettes", "gestational_age.Rmd"))
