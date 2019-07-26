$namespaces:
 arv: "http://arvados.org/cwl#"
 cwltool: "http://commonwl.org/cwltool#"
requirements:
  DockerRequirement:
    dockerPull: pythonmlnew
  ResourceRequirement:
    coresMin: 16
    ramMin: 32000
hints:
  cwltool:LoadListingRequirement: 
    loadListing: deep_listing
cwlVersion: v1.0
class: CommandLineTool
inputs: 
  glmnet_file:
    type: File
    inputBinding:
      position: 0
  X:
    type: File
    inputBinding:
      position: 1
  y:
    type: File
    inputBinding:
      position: 2

outputs: 
  best_lam:
    type: string

baseCommand: Rscript