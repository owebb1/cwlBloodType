# **** SVM_Trial.py ****
# * CREATED FOR: Curii Research
# * AUTHOR: Owen Webb
# * PURPOSE: To explore a linear SVC Model and predict phenotypes
# * USE: Used after data is encoded with filters applied
# * INPUT FILES: blood_type_A_chi2_no_augmentation_X.npy ; blood_type_A_chi2_no_augmentation_y.npy ;
#                blood_type_A_chi2_no_augmentation_pathdataoh.npy ; blood_type_A_chi2_no_augmentation_oldpath.npy ; 
#                blood_type_A_chi2_no_augmentation_varvals.npy
# * OUTPUT FILES: data_SVC_lams.csv

import numpy as np
import os
import scipy.sparse
from sklearn import svm, preprocessing, linear_model
from sklearn.model_selection import cross_val_score, cross_val_predict, train_test_split, GridSearchCV
from sklearn.svm import LinearSVC
from sklearn.metrics import confusion_matrix, accuracy_score
from collections import defaultdict
import matplotlib.pyplot as plt
import csv
import sys

print("==== NOW LOADING FILES... ====")

x_file = sys.argv[1]
y_file = sys.argv[2]
oldpath_file = sys.argv[3]
pathdata_file = sys.argv[4]
varvals_file = sys.argv[5]
lamstr = sys.argv[6]

X= scipy.sparse.load_npz(x_file)
y = np.load(y_file)

oldpath = np.load(oldpath_file)
pathdataOH = np.load(pathdata_file)
varvals = np.load(varvals_file)

fil = open("blood_type_A_chi2_no_augmentation.txt", "w+")
fil.write("Details: LinearSVC with L1 Regularization\n")
fil.write("==========================================================\n")

lamf = open(lamstr, "r")
str_best_lam = lamf.read()
best_lam = float(str_best_lam)

fil.write("Best Lambda: " + str(best_lam) +"\n")
print("Best Lambda: " + str(best_lam))

print("==== NOW FITTING TO BEST COEFFICEINT... ====")
# Fit the model with the best lambda
svc = LinearSVC(penalty='l1', class_weight='balanced', C=best_lam, dual=False)
svc.fit(X, y)

maxCoef = np.absolute(svc.coef_).max()
fil.write("Maximum Coefficent: " + str(maxCoef) + "\n")

max_idx = np.argmax(np.absolute(svc.coef_))
nonzero_num = np.nonzero(svc.coef_)[1].shape
fil.write("Number of Nonzero Coefficents: "+str(nonzero_num)+ "\n")

nonzero_idx_uk = np.nonzero(svc.coef_)[1]               #Gets indicies of nonzero coefficents
coefs = svc.coef_[0,:]                                  #gets the first part of coefficents

nonzero_coefs = coefs[nonzero_idx_uk]                   #gets all of the nonzero coefficents

sorted_idx = np.argsort(np.absolute(nonzero_coefs))     #returns indicies of a sorted ... does not actually sort
sorted_idx = np.flipud(sorted_idx)                      #flips all of the rows

nonzero_idx = nonzero_idx_uk[sorted_idx]                # gets all of the nonzero index's from the sorted one 
coefPaths = pathdataOH[nonzero_idx]                     # gets path data from the onehot for the indicies of the nonzero 

#From equation Sarah has, basically reversing encoding: 
tile_path = np.trunc(coefPaths/(16**5))
tile_step = np.trunc((coefPaths - tile_path*16**5)/2)
tile_phase = np.trunc((coefPaths- tile_path*16**5 - 2*tile_step))
tile_loc = np.column_stack((tile_path, tile_step))

fil.write("Tile Location: " + str(tile_loc)+"\n")
#fil.write("Nonzero Coefs: ", nonzero_coefs[sorted_idx])
#fil.write("Old Path: ", oldpath[nonzero_idx])
#fil.write("Varvals: ", varvals[nonzero_idx])
fil.close()

print("==== Done ====")