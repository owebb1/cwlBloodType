$namespaces:
 arv: "http://arvados.org/cwl#"
 cwltool: "http://commonwl.org/cwltool#"
requirements:
  DockerRequirement:
    dockerPull: l7g-ml/pythonr 
  ResourceRequirement:
    coresMin: 16
    ramMin: 32000
hints:
  cwltool:LoadListingRequirement: 
    loadListing: deep_listing
cwlVersion: v1.0
class: CommandLineTool
inputs: 
  svm_trial_file:
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
  pathdataoh:
    type: File
    inputBinding:
      position: 3
  oldpath:
    type: File
    inputBinding:
      position: 4
  varvals:
    type: File
    inputBinding:
      position: 5
  best_lam:
    type: File
    inputBinding:
      position: 6

outputs: 
  text_file:
    type: File
    outputBinding:
      glob: "*.txt"

baseCommand: python
  