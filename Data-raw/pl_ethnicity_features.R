## pl_ethnicity_features ---------------------------------------------------------------------------

# load object from local disc
pl_glmnet <- readRDS('Z:/Victor/Projects/DNAm-Ethnicity-Predictor/Robjects_final/05_glm_fit.rds')

# pull out the coefficients from glmnet model
coef <- coef(pl_glmnet, pl_glmnet$lambdaOpt)
coef <- data.frame(do.call("cbind", lapply(coef, function(x) x[,1])) )

# Remove coefficients = to 0
non_zero <- abs(rowSums(coef)) > 0
coef <- coef[non_zero,] # 1862, drops intercept automatically

# take out feature names
pl_ethnicity_features <- rownames(coef)

# save
use_data(pl_ethnicity_features, overwrite = T)
