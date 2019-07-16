$namespaces:
 arv: "http://arvados.org/cwl#"
 cwltool: "http://commonwl.org/cwltool#"
requirements:
  DockerRequirement:
    dockerPull: pythonmlnew
  ResourceRequirement:
    coresMin: 16
    ramMin: 100000
hints:
  cwltool:LoadListingRequirement: 
    loadListing: deep_listing
cwlVersion: v1.0
class: CommandLineTool
baseCommand: python
inputs:
  get_data_file:
    type: File
    default:
      class: File
      location: src/get_Data.py
    inputBinding:
      position: 0
  dbfile:
    type: File 
    inputBinding:
      position: 1
  allfile:
    type: File
    inputBinding:
      position: 2
  infofile:
    type: File
    inputBinding:
      position: 3
  namefile:
    type: File
    inputBinding:
      position: 4
  choice:
    type: string
    inputBinding:
      position: 5
  bloodtype:
    type: string
    inputBinding:
      position: 6
    
outputs:
  X:
    type: File
    outputBinding:
      glob: blood_type_A_chi2_no_augmentation_X.npz
  y:
    type: File
    outputBinding:
      glob: blood_type_A_chi2_no_augmentation_y.npy
  pathdataoh:
    type: File
    outputBinding:
      glob: pathdataOH.npy
  oldpath:
    type: File
    outputBinding:
      glob: oldpath.npy
  varvals:
    type: File
    outputBinding:
      glob: varvals.npy