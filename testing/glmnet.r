#!/usr/bin/env Rscript
#install.packages("glmnet", repos = "http://cran.us.r-project.org")



# Use RETICULATE to convert numpy arrays to r matrices
args = commandArgs(trailingOnly=TRUE)
library(glmnet)
#data(QuickStartExample)
if (length(args)==0) {
  stop("Need Correct Number of Arguments!", call.=FALSE)
} else if (length(args)==1) {
  # default output file
  args[2] = "out.txt"
}

cv10fold <- function(x, y) {
    cvfit = cv.glmnet(x,y)
    cvfit
    return(cvfit$lambda.min)
}

lammin <- cv10fold(x,y)

