#!/usr/bin/env Rscript
# install.packages("glmnet", repos = 'http://cran.us.r-project.org')
# install.packages("Matrix", repos = 'http://cran.us.r-project.org')
# install.packages("reticulate", repos = 'http://cran.us.r-project.org')

# Inorder to use Python
reticulate::use_python('/usr/local/bin/python3')
reticulate::py_discover_config()

# R libraries
library(glmnet)
library(reticulate)
library(Matrix)
library(methods)
setwd("/data-sdd/owebb/l7g-ml/BloodType/chi2/cwlBloodType")

# Python libraries
scipy <- import("scipy")
np <- import("numpy")

# Download and get nonzero indicies

args = commandArgs(trailingOnly=TRUE)

if (length(args)==0) {
  stop("At least two argument must be supplied: X (Sparse Matrix) and y (numpy array)", call.=FALSE)

# "/data-sdd/owebb/keep/by_id/su92l-4zz18-zkmbp64qbak0azs/blood_type_A_chi2_no_augmentation_X.npz"
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
# "/data-sdd/owebb/keep/by_id/su92l-4zz18-zkmbp64qbak0azs/blood_type_A_chi2_no_augmentation_y.npy"
ynump <- np$load(args[2]) 
y <- as.vector(ynump)

#cross validate and return the best lambda
cvfit = cv.glmnet(Xmat,y)

png(filename='testing/glmnet.png')
plot(cvfit)
dev.off()


message("Press Return To Continue")
invisible(readLines("stdin", n=1))

lammin <- cvfit$lambda.min
print(lammin)

# Still need to figure out what we want to return


