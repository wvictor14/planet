## glmfit objects for prediction -------------------------------------------------------------------

# load object from local disc
pl_glmnet <- readRDS('Z:/Victor/Projects/DNAm-Ethnicity-Predictor/Robjects_final/05_glm_fit.rds')

# a0
a0 <- pl_glmnet$a0
rownames(a0) <- rep("(Intercept)", nrow(a0))

# nbeta
nbeta <- pl_glmnet$beta # save this too

# nclass
nclass <- 3

# lambda tuning grid
lambda <- pl_glmnet$lambda
lamlist <- glmnet::lambda.interp(lambda, 0.01) # or this

# lambda
s <- pl_glmnet$lambdaOpt
nlambda <- length(s)

use_data(a0, nclass, nbeta, lamlist, s, nlambda, internal = T, overwrite = T)
