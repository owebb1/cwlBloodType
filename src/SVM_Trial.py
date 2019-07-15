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
import csv
import sys

print("==== NOW LOADING FILES... ====")

x_file = sys.argv[3]
y_file = sys.argv[4]
oldpath_file = sys.argv[5]
pathdata_file = sys.argv[6]
varvals_file = sys.argv[7]

X= scipy.sparse.load_npz(x_file)
y = np.load(y_file)

oldpath = np.load(oldpath_file)
pathdataOH = np.load(pathdata_file)
varvals = np.load(varvals_file)

fil = open("trials/SVM/blood_type_A_chi2_no_augmentation.txt", "w+")
fil.write("Details: LinearSVC with L1 Regularization\n")
fil.write("==========================================================\n")

print("==== NOW TRAINING MODEL... ====")
lam_range = np.logspace(-2, 1, 100).tolist()

scores = []
for lam in lam_range:
    one_lam_score = []
    svc_test = LinearSVC(penalty='l1', C=lam, dual=False) #SVC WITH L1 REGULARIZATION
    svc_test.fit(X,y)
    cross = cross_val_score(svc_test, X, y, cv=10) #Cross validation 10 fold
    mean = cross.mean()
    std = cross.std()
    one_lam_score.append(round(lam,3))
    one_lam_score.append(round(mean,3))
    one_lam_score.append(round(std,3))
    scores.append(one_lam_score)

# Used to then graph and look at best region of lambdavalues
with open('data_SVC_lams.csv', 'w') as csvFile:
        writer = csv.writer(csvFile)
        writer.writerows(scores)
csvFile.close()

#find the max lambda value
max_val = 0
max_lam = 0
for score in scores:
    if score[1] > max_val:
        max_val = score[1]
        max_lam = score[0]

best_lam = max_lam 
best_acc = max_val

print("==== NOW FITTING TO BEST COEFFICEINT... ====")
# Fit the model with the best lambda
svc = LinearSVC(penalty='l1', class_weight='balanced', C=best_lam, dual=False)
svc.fit(X, y)

maxCoef = np.absolute(svc.coef_).max()
print("Maximum Coefficent (%4.3f):" % maxCoef) 

max_idx = np.argmax(np.absolute(svc.coef_))
nonzero_num = np.nonzero(svc.coef_)[1].shape
print("Number of Nonzeros Coefficents (%d)" % nonzero_num)

nonzero_idx_uk = np.nonzero(svc.coef_)[1]               #Gets indicies of nonzero coefficents
coefs = svc.coef_[0,:]                                  #gets the first part of coefficents

nonzero_coefs = coefs[nonzero_idx_uk]                   #gets all of the nonzero coefficents

sorted_idx = np.argsort(np.absolute(nonzero_coefs))     #returns indicies of a sorted ... does not actually sort
sorted_idx = np.flipud(sorted_idx)                      #flips all of the rows

nonzero_idx = nonzero_idx_uk[sorted_idx]                # gets all of the nonzero index's from the sorted one 
coefPaths = pathdataOH[nonzero_idx]                     # gets path data from the onehot for the indicies of the nonzero 

#From equation Sarah has: 
tile_path = np.trunc(coefPaths/(16**5))
tile_step = np.trunc((coefPaths - tile_path*16**5)/2)
tile_phase = np.trunc((coefPaths- tile_path*16**5 - 2*tile_step))
tile_loc = np.column_stack((tile_path, tile_step))

print("Tile Location: ", tile_loc)
print("Nonzero Coefs: ", nonzero_coefs[sorted_idx])
print("Old Path: ", oldpath[nonzero_idx])
print("Varvals: ", varvals[nonzero_idx])