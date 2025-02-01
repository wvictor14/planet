# planet 1.15.3

# planet 1.15.2

# planet 1.15.1

* added predictPreclampsia 

# planet 1.9.4

# planet 1.9.3 (09-08-2023)

* add stop controls to `predictEthnicity`
* added some tests
* Bioconductor version bump

# planet 1.9.2

* Bioconductor version bump

# planet 1.9.1

* Bioconductor version bump

# planet 0.99.4 (03-10-2021)

* Combined vignettes into a single one
* Updated references

# planet 0.99.3 (01-22-2021)

* Update reference for cell composition
* Accepted into bioconductor, will be released in next cycle

# planet 0.99.2 (01-07-2021)

* Vignettes updated with new function names
* Removed `minfi` from examples since installation fails on some R versions
* Moved `.orig` files to `inst/script`
* Moved `data-raw/` contents to `inst/script` 
* Moved `man/figures/logo.png` to `inst/figures/logo.png`, updated README
* Lazydata set to false

# planet 0.99.0 (12-18-2020)

* Improved vignette figure quality
* Using github-actions check from `biocthis`
* Removed `viridis` from suggests
* Rewrote many data man pages

# planet 0.3.0 (12-17-2020)

* Final preparations for Bioconductor submission
* Changed license to => GPL-2
* More detailed attribution to glmnet
* Renamed all functions to camel case convention, including functions, data, 
tests, documentation, vignettes
* Added `planet-deprecated.R`
* `pl_infer_ethnicity()` and `pl_infer_age()` now deprecated, replaced with
`predictEthnicity` and `predictAge`, respectively.

# planet 0.2.36 (12-17-2020)

* Removed minfi dependency
* Addressed all fixable >line80 and 4 space indent notes from BiocCheck
* Precompiling vignettes.

# planet 0.2.35 (12-14-2020)

* added hexsticker
* updated zenodo doi
* added github actions
* added cells color palette
* favicons
* Fixed in-text citations in README

# planet 0.2.34 (12-11-2020)

* Reduced `nbeta` from 4 mb to 30 kb
* Removed `Matrix` dependency from imports

# planet 0.2.33 (12-11-2020)

* Fixed `pl_infer_age()` when missing CpGs
* Added tests for `pl_infer_age()` and `pl_infer_ethnicity()`
* Updated documentation

# planet 0.2.32 (12-11-2020)

* Added vignettes
* Reduced README significantly
* Format documentation for Bioconductor style
  * Added BiocViews to DESCRIPTION
  * Wrap lines max 80 characters
* Create CITATION
* Add Wendy Robinson to authors

# planet 0.2.3

* Fixes data export error on linux. See [#6](https://github.com/wvictor14/planet/pull/6#issuecomment-740147118)


# planet 0.2.2

* Export `nbeta`, instead of keeping internal
* This fixes the install errors
* On linux, data objects are not properly exported. See [#2](https://github.com/wvictor14/planet/issues/2)

# planet 0.2.1

* added syncytiotrophoblast reference cpgs

# planet 0.2.0

* added `pl_cell_cpgs_first` and `pl_cell_cpgs_third` for cell composition 
  inference

# planet 0.1.1

* copied glmnet:::glment_softmax code to be compatible with new glmnet version

# planet 0.1.0

* Added `pl_infer_age` to infer gestational age using Lee Y et al. placental DNAm clock.
* Modified example data to contain less probes and more samples, to save space but still be useful 
in the examples. 

# planet 0.0.1.9000

* Added a `NEWS.md` file to track changes to the package.
