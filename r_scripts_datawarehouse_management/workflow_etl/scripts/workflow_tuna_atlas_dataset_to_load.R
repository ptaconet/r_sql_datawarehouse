# workflow tuna atlas code list or code list mapping to load (already generated)

workflow_tuna_atlas_dataset_to_load<-function(con_parameters,metadata_and_parameterization){
  
  cat(paste0("Start processing dataset ",metadata_and_parameterization$persistent_identifier,"\n"))
  
  # Open the dataset
  dataset<-open_dataset(metadata_and_parameterization) 
  
  # Provide tuna atlas identifier
  metadata_and_parameterization$identifier<-metadata_and_parameterization$persistent_identifier
  
  # Generate metadata
  df_metadata<-rtunaatlas::generate_metadata(metadata_and_parameterization,dataset)
  
  # Open code list data frame. Either it is stored or it is generated in the dataset_and_metadata
  if (metadata_and_parameterization$dataset_type=="raw_dataset"){
    df_codelists<-get_data_frame_code_lists(metadata_and_parameterization)
  } 
  
  # Connect to db with admin rights
  drv <- dbDriver("PostgreSQL")
  con_admin <- dbConnect(drv, dbname=con_parameters$db_name, user=con_parameters$db_admin_name, password=con_parameters$db_admin_password, host=con_parameters$db_host)
  
  # Load dataset and metadata
  if (metadata_and_parameterization$dataset_type=="codelist"){
  rtunaatlas::load_codelist_in_db(con=con_admin,
                                  df_to_load=dataset,
                                  df_metadata=df_metadata)
  } else if (metadata_and_parameterization$dataset_type=="mapping"){
    rtunaatlas::load_mapping_in_db(con=con_admin,
                                    df_to_load=dataset,
                                    df_metadata=df_metadata)
  } else if (metadata_and_parameterization$dataset_type=="raw_dataset"){
    rtunaatlas::load_raw_dataset_in_db(con=con_admin,
                                   df_to_load=dataset,
                                   df_metadata=df_metadata,
                                   df_codelists_input=df_codelists)
  }
  
  dbDisconnect(con_admin)
  cat(paste0("End processing dataset ",metadata_and_parameterization$persistent_identifier,"\n"))
 
}