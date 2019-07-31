library(Matrix)
library(foreach)
suppressMessages(library(glmnet))
library(reticulate)
library(methods)

# Python libraries
scipy <- import("scipy")
np <- import("numpy")


Xscp <- scipy$sparse$load_npz('/data-sdd/owebb/keep/by_id/su92l-4zz18-qggqd0rz2e93vpg/blood_type_A_chi2_no_augmentation_X.npz')
xind <- Xscp$nonzero()

# Make them into an integer vector
i <- as.integer(xind[[1]]) + 1
j <- as.integer(xind[[2]]) + 1

# Collect nonzero data and put as vector
x <- as.vector(Xscp$data)

# Create a new sparse matrix
Xmat <- sparseMatrix(i,j,x = x)

# Load the y array and make into vector in R
ynump <- np$load('/data-sdd/owebb/keep/by_id/su92l-4zz18-qggqd0rz2e93vpg/blood_type_A_chi2_no_augmentation_y.npy') 
y <- as.vector(ynump)
lamvals <- 10^seq(0,-2, length=100)
#cross validate and return the best lambda
cvfit = cv.glmnet(Xmat,y, family = "binomial", type.measure = "class", nfolds = 5, lambda= lamvals)

lammin <- cvfit$lambda.min

# To Plot:
png('testing/plots/glmnet_class_flipped_2.png')
plot(cvfit)
dev.off()