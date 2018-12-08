# workflow_tuna_atlas_dataset_to_generate_and_load

  workflow_tuna_atlas_dataset_to_generate_and_load<-function(con_parameters,metadata_and_parameterization,year_tuna_atlas,vre_username,vre_token){
  
  cat(paste0("Start processing dataset ",metadata_and_parameterization$persistent_identifier,"\n"))
  
  # Generate dataset(s)
  dataset_and_metadata<-generate_dataset(metadata_and_parameterization)
  
  # in the case there is only 1 dataset in output of the script
  if (inherits(dataset_and_metadata$dataset, "data.frame")){
    dataset_and_metadata$dataset<-list(dataset_and_metadata$dataset)
    dataset_and_metadata$additional_metadata<-list(dataset_and_metadata$additional_metadata)
  }
  
  # One by one load the datasets with their metadata
  for (n_dataset_to_load in 1:length(dataset_and_metadata$dataset)){
  dataset<-dataset_and_metadata$dataset[[n_dataset_to_load]]
  additional_metadata<-dataset_and_metadata$additional_metadata[[n_dataset_to_load]]
  metadata_and_parameterization_this_df=metadata_and_parameterization
  
  # Complete metadata with values available in additional_metadata
  metadata_and_parameterization_this_df<-fill_missing_metadata(metadata_and_parameterization_this_df,additional_metadata)

  # Generate tuna atlas identifier
  metadata_and_parameterization_this_df$identifier<-generate_tuna_atlas_identifier(metadata_and_parameterization_this_df,dataset,year_tuna_atlas)
  
  # Push R script of dataset generation to the server
  metadata_and_parameterization_this_df<-push_R_script_to_server(metadata_and_parameterization_this_df,virtual_repository_with_R_files,vre_username,vre_token)
  
  # In the metadata, add the date of generation of the dataset
  metadata_and_parameterization_this_df$date_generation<-as.character(Sys.Date())
  
  # Generate metadata
  df_metadata<-rtunaatlas::generate_metadata(metadata_and_parameterization_this_df,dataset,additional_metadata=additional_metadata)
  
  # Open code list data frame. Either it is stored or it is generated in the dataset_and_metadata
  if (!is.na(metadata_and_parameterization_this_df$path_to_codelists_used_in_dataset)){
    df_codelists<-get_data_frame_code_lists(metadata_and_parameterization_this_df)
  } else {
    df_codelists<-dataset_and_metadata$df_codelists 
  }
  
  cat("Loading the dataset and the metadata in the DB...\n")
  
  # Connect to db with admin rights
  drv <- dbDriver("PostgreSQL")
  con_admin <- dbConnect(drv, dbname=con_parameters$db_name, user=con_parameters$db_admin_name, password=con_parameters$db_admin_password, host=con_parameters$db_host)
  
  # Load dataset and metadata
    rtunaatlas::load_raw_dataset_in_db(con=con_admin,
                                       df_to_load=dataset,
                                       df_metadata=df_metadata,
                                       df_codelists_input=df_codelists)
    
    dbDisconnect(con_admin)
    
  cat("Loading the dataset and the metadata in the DB OK\n")
  cat(paste0("End processing dataset ",metadata_and_parameterization_this_df$persistent_identifier,"\n"))
  
  }
  
}
