#!/usr/bin/env Rscript
# install.packages("glmnet", repos = 'http://cran.us.r-project.org')
# install.packages("Matrix", repos = 'http://cran.us.r-project.org')
# install.packages("reticulate", repos = 'http://cran.us.r-project.org')

# Inorder to use Python
#reticulate::use_python('/usr/local/bin/python3')
#reticulate::py_discover_config()

# R libraries
library(Matrix)
library(foreach)
suppressMessages(library(glmnet))
library(reticulate)
library(methods)

# Python libraries
scipy <- import("scipy")
np <- import("numpy")

args = commandArgs(trailingOnly=TRUE)

if (length(args)==0) {
  stop("At least two argument must be supplied: X (Sparse Matrix) and y (numpy array)", call.=FALSE)
}

# /data-sdd/owebb/keep/by_id/su92l-4zz18-qggqd0rz2e93vpg/blood_type_A_chi2_no_augmentation_X.npz
Xscp <- scipy$sparse$load_npz(args[1])
xind <- Xscp$nonzero()

# Make them into an integer vector
i <- as.integer(xind[[1]]) + 1
j <- as.integer(xind[[2]]) + 1

# Collect nonzero data and put as vector
x <- as.vector(Xscp$data)

# Create a new sparse matrix
Xmat <- sparseMatrix(i,j,x = x)

# Load the y array and make into vector in R
# /data-sdd/owebb/keep/by_id/su92l-4zz18-qggqd0rz2e93vpg/blood_type_A_chi2_no_augmentation_y.npy
ynump <- np$load(args[2]) 
y <- as.vector(ynump)

#cross validate and return the best lambda
maxlog <- 0
minlog <- -2
lamvals <- 10^seq(maxlog,minlog, length=100)
cvfit = cv.glmnet(Xmat,y, family = "binomial", type.measure = "class", nfolds = 5, lambda=lamvals)

lammin <- cvfit$lambda.min

txtfile<-file("lammin.txt")
writeLines(as.character(lammin), txtfile)
close(txtfile)


filename <- paste0('glmnet_class.png')
png(filename)
plot(cvfit)
dev.off()

