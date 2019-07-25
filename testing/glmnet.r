#!/usr/bin/env Rscript

#install.packages("glmnet", repos = "http://cran.us.r-project.org")

# Inorder to use Python
reticulate::use_python('/usr/local/bin/python3')
reticulate::py_discover_config()

# R libraries
library(glmnet)
library(reticulate)
library(Matrix)

# Use a anaconda enviorment
conda_create("r-reticulate")
conda_install("r-reticulate", "scipy")
scipy <- import("scipy")
np <- import("numpy")

# Download and get nonzero indicies
Xscp <- scipy$sparse$load_npz("small.npz")
xind <- Xscp$nonzero()

# Make them into an integer vector
i <- as.integer(xind[[1]]) + 1
j <- as.integer(xind[[2]]) + 1

# Collect nonzero data and put as vector
x <- as.vector(Xscp$data)

# Create a new sparse matrix
Xmat <- sparseMatrix(i,j,x = x)

# Load the y array and make into vector in R
ynump <- np$load("smallarray.npy") 
y <- as.vector(ynump)

#cross validate and return the best lambda
cvfit = cv.glmnet(Xmat,y)
lammin <- cvfit$lambda.min
print(lammin)



