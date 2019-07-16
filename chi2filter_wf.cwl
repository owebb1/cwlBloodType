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

outputs: 
  text_file: 
    type: File
    outputSource: svmtrial/text_file
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
      # X:
      #   type: File
      #   outputBinding:
      #     glob: blood_type_A_chi2_no_augmentation_X.npz
      # y:
      #   type: File
      #   outputBinding:
      #     glob: blood_type_A_chi2_no_augmentation_y.npy
      # pathdataoh:
      #   type: File
      #   outputBinding:
      #     glob: pathdataOH.npy
      # oldpath:
      #   type: File
      #   outputBinding:
      #     glob: oldpath.npy
      # varvals:
      #   type: File
      #   outputBinding:
      #     glob: varvals.npy
    run: getting_data.cwl

  svmtrial:
    in:
      svm_trial_file: svm_trial_file
      X: gettingdata/X
      y: gettingdata/y
      pathdataoh: gettingdata/pathdataoh
      oldpath: gettingdata/oldpath
      varvals: gettingdata/varvals
    out: [text_file]
      # text_file:
      #   type: File
      #   outputBinding:
      #     glob: "*.txt"
    run: svm.cwl
      