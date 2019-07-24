import numpy as np
import sys

allfile = sys.argv[1]
print (allfile)
print ("==== Loading File... ====")
x = np.load(allfile)
print ("==== Done Loading ====")