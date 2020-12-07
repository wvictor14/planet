## glmfit objects for prediction -------------------------------------------------------------------
# Here I take apart the glm_fit object because some components are really large and not necessary.
#
# load object from local disc
pl_glmnet <- readRDS('Z:/Victor/Projects/DNAm-Ethnicity-Predictor/Robjects_final/05_glm_fit.rds')

############ model parameters
# a0
a0 <- pl_glmnet$a0
rownames(a0) <- rep("(Intercept)", nrow(a0))

# nbeta
nbeta <- pl_glmnet$beta # save this too

# nclass
nclass <- 3

# lambda tuning grid
lambda <- pl_glmnet$lambda
lamlist <- glmnet:::lambda.interp(lambda, 0.01) # or this

# lambda
s <- pl_glmnet$lambdaOpt
nlambda <- length(s)

############### pull out the coefficients from glmnet model
coef <- coef(pl_glmnet, pl_glmnet$lambdaOpt)
coef <- data.frame(do.call("cbind", lapply(coef, function(x) x[,1])) )

# Remove coefficients = to 0
non_zero <- abs(rowSums(coef)) > 0
coef <- coef[non_zero,] # 1860 + 1 intercept

# take out feature names
pl_ethnicity_features <- rownames(coef)[2:nrow(coef)] # remove intercept

############### save
usethis::use_data(a0, nclass, 
                  #nbeta, 
                  lamlist, s, nlambda,
                   internal = TRUE)
usethis::use_data(nbeta, internal = FALSE) # ideally this should be internal but this causes installation errors on linux (and maybe mac?)
usethis::use_data(pl_ethnicity_features, internal = FALSE, overwrite = TRUE)
