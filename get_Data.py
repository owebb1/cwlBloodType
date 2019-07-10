# **** get_Data.py ****
# * CREATED FOR: Curii Research
# * AUTHOR: Owen Webb
# * PURPOSE: To process tiled numpy arrays and run a chi2 filter on it 
# * USE: Used prior to ML algorithm Ex: SVM_Trial.py
# * INPUT FILES: untap.db ; all.npy ; all-info.npy ; names.npy
# * OUTPUT FILES: blood_type_A_chi2_no_augmentation_X.npy ; blood_type_A_chi2_no_augmentation_y.npy ;
#                 blood_type_A_chi2_no_augmentation_pathdataoh.npy ; blood_type_A_chi2_no_augmentation_oldpath.npy ; 
#                 blood_type_A_chi2_no_augmentation_varvals.npy

import csv
import numpy as np
import sqlite3
import seaborn as sns
import pandas as pd
import os
import sys

import scipy.sparse
from scipy.sparse import csr_matrix
from scipy.sparse import hstack

from sklearn.feature_selection import chi2
from sklearn.preprocessing import OneHotEncoder


untapdb = sys.argv[1]
allfile = sys.argv[2]
infofile = sys.argv[3]
namesfile = sys.argv[4]
choice = sys.argv[5]
if choice.lower() == "blood":
    bloodtype = sys.argv[6]

# Unnecesary if cwl is run
# untapdb = '/data-sdd/cwl_tiling/datafiles/untap.db'
# allfile = '/home/owebb/keep/by_id/su92l-j7d0g-4mnq9juobvg0qwy/CopyOfTileDataNumpy/all.npy'
# infofile = '/home/owebb/keep/by_id/su92l-j7d0g-4mnq9juobvg0qwy/CopyOfTileDataNumpy/all-info.npy'
# namesfile = '/home/owebb/keep/by_id/su92l-j7d0g-4mnq9juobvg0qwy/CopyOfTileDataNumpy/names.npy'
# bloodtype = 'A'

print("==== Working On Files... =====")

# Go get the data from the database as and create dataframe
print("untap: ", untapdb)
print("all: ", allfile)
print(type(allfile))
print("info: ", infofile)
print("names: ", namesfile)
conn = sqlite3.connect(untapdb)
c = conn.cursor()
c.execute('SELECT * FROM demographics')
rows = c.fetchall()
colnames = []
for i in c.description:
    colnames.append(i[0])
data = pd.DataFrame(rows, columns=colnames)
conn.close()

dataBloodType = data[['human_id','blood_type']]
dataBloodType = dataBloodType.replace('', np.nan, inplace=False)
dataBloodType = dataBloodType.dropna(axis=0, inplace=False)

#Encodes blood type to integers
dataBloodType['A'] = dataBloodType['blood_type'].str.contains('A',na=False).astype(int)
dataBloodType['B'] = dataBloodType['blood_type'].str.contains('B',na=False).astype(int)
dataBloodType['Rh'] = dataBloodType['blood_type'].str.contains('\+',na=False).astype(int)

print("==== Loading Files... ====")
Xtrain = np.load(allfile)
print(Xtrain.shape)
Xtrain += 2 # All -2 so makes it to 0
pathdata = np.load(infofile)
names_file = open(namesfile, 'r') #not a "pickeled" file, so must just read it and pull data out of it
names = []
for line in names_file:
    names.append(line[45:54][:-1])

dataBloodType.human_id = dataBloodType.human_id.str.lower()
results = []
for name in names:
    results.append(name.lower())

df_names = pd.DataFrame(results,columns={'Sample'})
df_names['Number'] = df_names.index

df2 = df_names.merge(dataBloodType,left_on = 'Sample', right_on='human_id', how='inner')
del dataBloodType
df2['blood_type'].value_counts()
del df_names
idx = df2['Number'].values

Xtrain = Xtrain[idx,:] 

min_indicator = np.amin(Xtrain, axis=0)
max_indicator = np.amax(Xtrain, axis=0)

sameTile = min_indicator == max_indicator
skipTile = ~sameTile #this is the inverse operator for boolean

idxOP = np.arange(Xtrain.shape[1])
Xtrain = Xtrain[:, skipTile]
newPaths = pathdata[skipTile]
idxOP = idxOP[skipTile]
# only keep data with less than 10% missing data
nnz = np.count_nonzero(Xtrain, axis=0)
fracnnz = np.divide(nnz.astype(float), Xtrain.shape[0])
idxKeep = fracnnz >= 0.9
Xtrain = Xtrain[:, idxKeep]

print("==== Extracting Blood Type %s... ====" %bloodtype)
y = df2[bloodtype].values #for blood type A to start

# save information about deleted missing/spanning data
varvals = np.full(50 * Xtrain.shape[1], np.nan)
nx = 0
varlist = []
for j in range(0, Xtrain.shape[1]):
    u = np.unique(Xtrain[:,j])
    varvals[nx : nx + u.size] = u
    nx = nx + u.size
    varlist.append(u)

varvals = varvals[~np.isnan(varvals)]

def foo(col):
    u = np.unique(col)
    nunq = u.shape
    return nunq

invals = np.apply_along_axis(foo, 0, Xtrain)
invals = invals[0]

# used later to find coefPaths
pathdataOH = np.repeat(newPaths[idxKeep], invals)
# used later to find the original location of the path from non one hot encode
oldpath = np.repeat(idxOP[idxKeep], invals)

randomize_idx = np.arange(len(y))
np.random.shuffle(randomize_idx)
tiledata = Xtrain[randomize_idx,:]
y = y[randomize_idx]

nnz = np.count_nonzero(tiledata,axis=0)

print("==== One-hot Encoding Data... ====")

data_shape = tiledata.shape[1]

parts = 4
idx = np.linspace(0,data_shape,num=parts).astype('int')
Xtrain2 = csr_matrix(np.empty([tiledata.shape[0], 0]))
pidx = np.empty([0,],dtype='bool')

i = 1
for chunk in range(0,parts-1):
    min_idx = idx[chunk]
    max_idx = idx[chunk+1]
    enc = OneHotEncoder(sparse=True, dtype=np.uint16)
    # 1-hot encoding tiled data
    Xtrain = enc.fit_transform(tiledata[:,min_idx:max_idx])
    [chi2val,pval] = chi2(Xtrain, y)
    pidxchunk = pval <= 0.02
    Xchunk = Xtrain[:,pidxchunk]
    pidx=np.concatenate((pidx,pidxchunk),axis=0)
    Xtrain2=hstack([Xtrain2,Xchunk],format='csr')
    i += 1

pathdataOH = pathdataOH[pidx]
oldpath = oldpath[pidx]
varvals = varvals[pidx]
Xtrain = Xtrain2
to_keep = varvals > 2 
idkTK = np.nonzero(to_keep)
idkTK = idkTK[0]

Xtrain = Xtrain[:,idkTK]
pathdataOH = pathdataOH[idkTK]
oldpath = oldpath[idkTK]
varvals = varvals[idkTK]

print(Xtrain.shape)
print(y.shape)
print(pathdataOH.shape)
print(oldpath.shape)
print(varvals.shape)

filenameheader = "./harvested_data/"

X_filename = "blood_type_A_chi2_no_augmentation_X.npz"
y_filename = "blood_type_A_chi2_no_augmentation_y.npy"
np.save(filenameheader+ y_filename, y)
np.save(filenameheader+'pathdataOH.npy', pathdataOH)
np.save(filenameheader+'oldpath.npy', oldpath)
np.save(filenameheader+'varvals.npy', varvals)
scipy.sparse.save_npz(filenameheader+ X_filename, Xtrain)



print("==== Done ====")