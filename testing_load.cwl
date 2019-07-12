requirements:
  DockerRequirement:
    dockerPull: pythonml
  ResourceRequirement:
    coresMin: 16
    ramMin: 10000
cwlVersion: v1.0
class: CommandLineTool
# baseCommand: python
inputs:
  load_file:
    type: File
    default: 
      class: File
      location: src/load_file.py
    inputBinding: 
      position: 0
  allfile:
    type: File
    inputBinding:
      position: 1
outputs: []
baseCommand: python
# arguments:
#   - $(inputs.load_file)
#   - $(inputs.allfile)
