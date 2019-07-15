$namespaces:
 arv: "http://arvados.org/cwl#"
 cwltool: "http://commonwl.org/cwltool#"
requirements:
  DockerRequirement:
    dockerPull: pythonml
  ResourceRequirement:
    coresMin: 16
    ramMin: 60000
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
      glob: "*harvested_data/blood_type_A_chi2_no_augmentation_X.npz"
  y:
    type: File
    outputBinding:
      glob: "*harvested_data/blood_type_A_chi2_no_augmentation_y.npy"
  pathdataoh:
    type: File
    outputBinding:
      glob: "*harvested_data/pathdataoh.npy"
  oldpath:
    type: File
    outputBinding:
      glob: "*harvested_data/oldpath.npy"
  varvals:
    type: File
    outputBinding:
      glob: "*harvested_data/varvals.npy"