## Generate the dataset from the R script

## metadada_and_parameterization has to contain:
# - 1 element named 'path_to_script_dataset_generation' containing the path to the R script that generates the dataset
# - the list of parameters for this R script with the associated values

## Return: 
# - the dataset properly structured
# - [Optional] some metadata elements in a list. These metadata elements will be added to the existing ones 
# - [Optional] the data frame of code lists to use to load the dataset in the DB

generate_dataset<-function(metadata_and_parameterization){
  
  # Get input parameters for the script
  parameters_columns<-colnames(metadata_and_parameterization)[which(grepl("parameter_",colnames(metadata_and_parameterization)))]
  for (i in 1:length(parameters_columns)){
    parameter_name=gsub("parameter_","",parameters_columns[i])
    assign(parameter_name, metadata_and_parameterization[,parameters_columns[i]],envir=.GlobalEnv)
    # Change "NULL" by NULL
    if (get(parameter_name)=="NULL"){
      assign(parameter_name, NULL,envir=.GlobalEnv)
    }
  }
  
  ## Source script to generate the dataset, with above parameterization
  cat("Starting generation of the dataset...\n")
  source(metadata_and_parameterization$path_to_script_dataset_generation)
  #dataset<-data.frame(dataset)
  
  cat("End generation of the dataset\n")
  
  if(!(exists("additional_metadata"))){
    additional_metadata<-NULL
  }
  if(!(exists("df_codelists"))){
    df_codelists<-NULL
  }
  
  return(list(dataset=dataset,additional_metadata=additional_metadata,df_codelists=df_codelists))
}
