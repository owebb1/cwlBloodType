import subprocess

command = 'Rscript'
path2script = 'testing/glmnet.R'
cmd = [command, path2script]
x = subprocess.check_output(cmd,universal_newlines=True)
#print(x)