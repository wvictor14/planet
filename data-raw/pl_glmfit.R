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

# some glmnet processing
for (i in seq(nclass)) {
  kbeta <- methods::rbind2(a0[i, , drop = FALSE], nbeta[[i]]) # was rbind2
  vnames <- dimnames(kbeta)[[1]]
  dimnames(kbeta) <- list(NULL, NULL)
  kbeta <- kbeta[, lamlist$left, drop = FALSE] %*% 
    Matrix::Diagonal(x = lamlist$frac) +
    kbeta[, lamlist$right, drop = FALSE] %*% 
    Matrix::Diagonal(x = 1 - lamlist$frac)
  dimnames(kbeta) <- list(vnames, paste(seq(along = s)))
  nbeta[[i]] <- kbeta
}

# reduce nbeta
nbeta2 <- nbeta

## explore nbeta structure
library(dplyr)
test1 <- nbeta2$African %>% as.matrix()
test1 <- rownames(test1)[rowSums(test1) >0 ] 

test2 <- nbeta2$Asian %>% as.matrix()
test2 <- rownames(test2)[rowSums(test2) >0 ] 

test3 <- nbeta2$Caucasian %>% as.matrix()
test3 <- rownames(test3)[rowSums(test3) >0 ] 

all(c(test1, test2, test3) %in% c("(Intercept)", pl_ethnicity_features))

# subset each dgcmatrix to non-zero coefficients
nbeta$African <- 
  nbeta$African[c('(Intercept)', pl_ethnicity_features),,drop=FALSE]
nbeta$Asian <- 
  nbeta$Asian[c('(Intercept)', pl_ethnicity_features),,drop=FALSE]
nbeta$Caucasian <- 
  nbeta$Caucasian[c('(Intercept)', pl_ethnicity_features),,drop = FALSE]

############### save
usethis::use_data(a0, nclass, 
                  #nbeta, 
                  lamlist, s, nlambda,
                   internal = TRUE)
usethis::use_data(nbeta, internal = FALSE) # ideally this should be internal but this causes installation errors on linux (and maybe mac?)
usethis::use_data(pl_ethnicity_features, internal = FALSE, overwrite = TRUE)
