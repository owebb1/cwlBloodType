$namespaces:
 arv: "http://arvados.org/cwl#"
 cwltool: "http://commonwl.org/cwltool#"
requirements:
  DockerRequirement:
    dockerPull: pythonml
  ResourceRequirement:
    coresMin: 16
    ramMin: 100000
hints:
  cwltool:LoadListingRequirement: 
    loadListing: deep_listing
    
cwlVersion: v1.0
class: Workflow
inputs:
  get_data_file:
    type: File
    inputBinding:
      position: 1

  svm_trial_file:
    type: File
    inputBinding:
      position: 2
  dbfile:
    type: File 
    inputBinding:
      position: 3

  allfile:
    type: File
    inputBinding:
      position: 4
  
  infofile:
    type: File
    inputBinding:
      position: 5

  namefile:
    type: File
    inputBinding:
      position: 6
  
  choice:
    type: string
    inputBinding:
      position: 7

  bloodtype:
    type: string
    inputBinding:
      position: 8

outputs: []
steps:
  gettingdata:
    in:
      get_data_file: get_data_file
      dbfile: dbfile
      allfile: allfile
      infofile: infofile
      namefile: namefile
      choice: choice
      bloodtype: bloodtype
    out: [X,y,pathdataoh, oldpath, varvals]
    run: getting_data.cwl

  svmtrial:
    in:
      svm_trial_file: svm_trial_file
      X: gettingdata/X
      y: gettingdata/y
      pathdataoh: gettingdata/pathdataoh
      oldpath: gettingdata/oldpath
      varvals: gettingdata/varvals
    out: []
    run: svm.cwl
      