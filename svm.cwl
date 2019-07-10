cwlVersion: v1.0
class: CommandLineTool
baseCommand: python
inputs: 
  svm_trial_file:
    type: File
    inputBinding:
      position: 1
  X:
    type: File
  y:
    type: File
  pathdataoh:
    type: File
  oldpath:
    type: File
  varvals:
    type: File
outputs: []