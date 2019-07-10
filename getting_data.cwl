cwlVersion: v1.0
class: CommandLineTool
baseCommand: python
requirements:
  DockerRequirement:
    dockerPull: "l7g-ml/python-ml"
  ResourceRequirement:
    coresMin: 16
inputs:
  get_data_file:
    type: File
    inputBinding:
      position: 1
  dbfile:
    type: File 
    inputBinding:
      position: 2
  allfile:
    type: File
    inputBinding:
      position: 3
  infofile:
    type: File
    inputBinding:
      position: 4
  namefile:
    type: File
    inputBinding:
      position: 5
  choice:
    type: string
    inputBinding:
      position: 6
  bloodtype:
    type: string
    inputBinding:
      position: 7
    
outputs:
  X:
    type: File
    outputBinding:
      glob: "*X.npz"
  y:
    type: File
    outputBinding:
      glob: "*y.npy"
  pathdataoh:
    type: File
    outputBinding:
      glob: "*pathdataoh.npy"
  oldpath:
    type: File
    outputBinding:
      glob: "*oldpath.npy"
  varvals:
    type: File
    outputBinding:
      glob: "*varvals.npy"

arguments:
  - $(inputs.get_data_file)
  - $(inputs.dbfile)
  - $(inputs.allfile.basename)
  - $(inputs.infofile.basename)
  - $(inputs.namefile.basename)
  - $(inputs.choice)
  - $(inputs.bloodtype)