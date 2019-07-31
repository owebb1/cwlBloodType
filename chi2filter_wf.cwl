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
  glmnet_file:
    type: File
    inputBinding:
      position: 3
  dbfile:
    type: File 
    inputBinding:
      position: 4

  allfile:
    type: File
    inputBinding:
      position: 5
  
  infofile:
    type: File
    inputBinding:
      position: 6

  namefile:
    type: File
    inputBinding:
      position: 7
  
  choice:
    type: string
    inputBinding:
      position: 8

  bloodtype:
    type: string
    inputBinding:
      position: 9

outputs: 
  text_file: 
    type: File
    outputSource: svmtrial/text_file
  graph:
    type: File
    outputSource: glmnet/graph
    
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
    out: [X, y, pathdataoh, oldpath, varvals]
    run: getting_data.cwl

  glmnet:
    in:
      glmnet_file: glmnet_file
      X: gettingdata/X
      y: gettingdata/y
    out: [best_lam,graph]
    run: glmnet.cwl

  svmtrial:
    in:
      svm_trial_file: svm_trial_file
      X: gettingdata/X
      y: gettingdata/y
      pathdataoh: gettingdata/pathdataoh
      oldpath: gettingdata/oldpath
      varvals: gettingdata/varvals
      best_lam: glmnet/best_lam
    out: [text_file]
    run: svm.cwl
      