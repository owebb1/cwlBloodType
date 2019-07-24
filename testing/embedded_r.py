import rpy2
from scipy.sparse import random as sparan
from rpy2.robjects.packages import importr
import rpy2.robjects as ro
import numpy as np
import rpy2.robjects.numpy2ri
rpy2.robjects.numpy2ri.activate()

#TODO: Import glmnet and everything else required for R
base = importr('base')
utils = importr('utils')
import rpy2.robjects.packages as rpackages
glm = importr('glmnet')

#TODO: Create a sparse matrix
x = sparan(100,10)

#TODO: Create a normal numpy array
y = np.random.rand(100,1)

#TODO: Pass in data in the correct form
nr,nc = y.shape
y = ro.r.matrix(y, nrow=nr, ncol=nc)
ro.r.assign("y", y)


#TODO: run glmnet and plot

# robjects.r(
#     #Enter the string into the r object and will execute the string as r code making it easy run small scripts
#     '''
#     library(glmnet)
#     cv10fold <- function(x, y) {
#         cvfit = cv.glmnet(x,y)
#         cvfit
#         return(cvfit$lambda.min)
#     }
#     lammin <- cv10fold(x,y)
#     '''
# )

#TODO: Figure out how to return objects... it will find our best lambda.min for us