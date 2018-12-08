######################################################################
##### 52North WPS annotations ##########
######################################################################
# wps.des: id = workflow_setup_update_tuna_atlas, title = Setup or update the tuna atlas database , abstract = This script enable to setup or update the tuna atlas database;
# wps.in: id = deploy_database_model, type = boolean, title = MANDATORY. Deploy the database model on the empty PostgreSQL+PostGIS database ? , value = TRUE;
# wps.in: id = load_codelists, type = boolean, title = MANDATORY. Load code lists in the database ? If set to TRUE then following parameter(s) is/are mandatory: metadata_and_parameterization_csv_codelists , value = TRUE;
# wps.in: id = load_codelists_mappings, type = boolean, title = MANDATORY. Load code list mappings in the database ? If set to TRUE then following parameter(s) is/are mandatory: metadata_and_parameterization_csv_mappings, value = TRUE;
# wps.in: id = year_tuna_atlas, type = string, title = Year of the Tuna atlas to setup/update (i.e. year the datasets to load were released by the tuna RFMOs) , value = "2017";
# wps.in: id = transform_and_load_primary_datasets, type = boolean, title = MANDATORY. Harmonize structure and load primary tuna RFMOs datasets in the database ? If set to TRUE then following parameter(s) is/are mandatory: virtual_repository_with_R_files | vre_username | vre_token | metadata_and_parameterization_csv_primary_datasets., value = TRUE;
# wps.in: id = generate_and_load_global_tuna_atlas_datasets, type = boolean, title = MANDATORY. Generate and load global tuna atlas datasets in the database ? If set to TRUE then following parameter(s) is/are mandatory: virtual_repository_with_R_files | vre_username | vre_token | metadata_and_parameterization_ird_tuna_atlas_catch_datasets | metadata_and_parameterization_ird_tuna_atlas_nominal_catch_datasets., value = TRUE;
# wps.in: id = db_host, type = string, title = MANDATORY. Host of the database , value = "db-tuna.d4science.org";
# wps.in: id = db_name, type = string, title = MANDATORY. Name of the database , value = "tunaatlas";
# wps.in: id = db_admin_name, type = string, title = MANDATORY. User name of the database (admin) , value = "tunaatlas_u";
# wps.in: id = db_admin_password, type = string, title = MANDATORY. Password of the admin of the database , value = "***";
# wps.in: id = db_read_name, type = string, title = OPTIONAL unless deploy_database_model==TRUE. User name of the database (select privileges) , value = "tunaatlas_inv";
# wps.in: id = db_dimensions, type = string, title = Name of the dimensions to deploy. The dimensions must be separated by a comma. , value = "area,catchtype,unit,flag,gear,schooltype,sex,sizeclass,species,time,source";
# wps.in: id = db_variables_and_associated_dimensions, type = string, title = Name of the variables to deploy and their associated dimensions. The format is: variable_name=list_of_dimensions_associated_separated_by_commas. The variables should be separated by the symbol '@'. , value = "catch=schooltype,species,time,area,gear,flag,catchtype,unit,source@effort=schooltype,time,area,gear,flag,unit,source@catch_at_size=schooltype,species,time,area,gear,flag,catchtype,sex,unit,sizeclass,source";
# wps.in: id = virtual_repository_with_R_files, type = string, title = OPTIONAL unless transform_and_load_primary_datasets==TRUE or generate_and_load_global_tuna_atlas_datasets==TRUE. Repository where the R scripts of data generation will be loaded. , value = "/Workspace/VRE Folders/FAO_TunaAtlas/R_scripts/datasets_creation";
# wps.in: id = vre_username, type = string, title = OPTIONAL unless transform_and_load_primary_datasets==TRUE or generate_and_load_global_tuna_atlas_datasets==TRUE. VRE user name , value = "paultaconet";
# wps.in: id = vre_token, type = string, title = OPTIONAL unless transform_and_load_primary_datasets==TRUE or generate_and_load_global_tuna_atlas_datasets==TRUE. VRE token , value = "***";
# wps.in: id = metadata_and_parameterization_csv_codelists, type = string, title = OPTIONAL unless load_codelists==TRUE. Path to the table containing the metadata and parameters for the code lists to load in the DB. See documentation to understand how this table must be filled. , value = "https://raw.githubusercontent.com/ptaconet/rtunaatlas_scripts/master/tunaatlas_world/metadata_and_parameterization_files/metadata_codelists_2017.csv";
# wps.in: id = metadata_and_parameterization_csv_mappings, type = string, title = OPTIONAL unless load_codelists_mappings==TRUE. Path to the table containing the metadata and parameters for the code lists mappings to load in the DB. See documentation to understand how this table must be filled. , value = "https://raw.githubusercontent.com/ptaconet/rtunaatlas_scripts/master/tunaatlas_world/metadata_and_parameterization_files/metadata_mappings_2017.csv";
# wps.in: id = metadata_and_parameterization_csv_primary_datasets, type = string, title = OPTIONAL unless transform_and_load_primary_datasets==TRUE. Path to the table containing the metadata and parameters for the primary tuna RFMOs to load in the DB. See documentation to understand how this table must be filled. , value = "https://raw.githubusercontent.com/ptaconet/rtunaatlas_scripts/master/tunaatlas_world/metadata_and_parameterization_files/metadata_and_parameterization_primary_datasets_2017.csv";
# wps.in: id = metadata_and_parameterization_tuna_atlas_catch_effort_datasets, type = string, title = OPTIONAL unless generate_and_load_global_tuna_atlas_datasets==TRUE. Path to the table containing the metadata and parameters for the global georeferenced catch tuna atlas datasets to generate and load in the DB. See documentation to understand how this table must be filled. , value = "https://raw.githubusercontent.com/ptaconet/rtunaatlas_scripts/master/tunaatlas_world/metadata_and_parameterization_files/metadata_and_parameterization_tuna_atlas_datasets_ird_2017.csv";
# wps.in: id = metadata_and_parameterization_tuna_atlas_nominal_catch_datasets, type = string, title = OPTIONAL unless generate_and_load_global_tuna_atlas_datasets==TRUE. Path to the table containing the metadata and parameters for the global nominal catch tuna atlas datasets to generate and load in the DB. See documentation to understand how this table must be filled. , value = "https://raw.githubusercontent.com/ptaconet/rtunaatlas_scripts/master/tunaatlas_world/metadata_and_parameterization_files/metadata_and_parameterization_tuna_atlas_nominal_catch_datasets_2017.csv";
# wps.out: id = , type = , title = Database deployed (in case deploy_database_model==TRUE) and loaded with the datasets; 

rm(list=ls(all=TRUE))

### MANDATORY PARAMETERS
year_tuna_atlas="2017"
deploy_database_model=TRUE
load_codelists=TRUE
load_codelists_mappings=TRUE
transform_and_load_primary_datasets=TRUE
generate_and_load_global_tuna_atlas_datasets=TRUE
virtual_repository_with_R_files="/Workspace/VRE Folders/FAO_TunaAtlas/R_scripts/datasets_creation"
vre_username="paultaconet"
vre_token="***"
db_host="db-tuna.d4science.org"
db_name="tunaatlas"
db_admin_name="tunaatlas_u"
db_admin_password="***"

### OPTIONAL PARAMETERS depending on the values set in the mandatory parameters
## db_read_name,dimensions,variables_and_associated_dimensions : fill-in only if deploy_database_model==TRUE
db_read_name="tunaatlas_inv"
db_dimensions="area,catchtype,unit,flag,gear,schooltype,sex,sizeclass,species,time,source"
db_variables_and_associated_dimensions="catch=schooltype,species,time,area,gear,flag,catchtype,unit,source@effort=schooltype,time,area,gear,flag,unit,source@catch_at_size=schooltype,species,time,area,gear,flag,catchtype,sex,unit,sizeclass,source"

## metadata_and_parameterization_csv_codelists : fill-in only if load_codelists==TRUE
metadata_and_parameterization_csv_codelists="https://raw.githubusercontent.com/ptaconet/rtunaatlas_scripts/master/tunaatlas_world/metadata_and_parameterization_files/metadata_codelists_2017.csv"

## metadata_and_parameterization_csv_mappings : fill-in only if load_codelists_mappings==TRUE
metadata_and_parameterization_csv_mappings="https://raw.githubusercontent.com/ptaconet/rtunaatlas_scripts/master/tunaatlas_world/metadata_and_parameterization_files/metadata_mappings_2017.csv"

## metadata_and_parameterization_csv_primary_datasets : fill-in only if transform_and_load_primary_datasets==TRUE
metadata_and_parameterization_csv_primary_datasets="https://raw.githubusercontent.com/ptaconet/rtunaatlas_scripts/master/tunaatlas_world/metadata_and_parameterization_files/metadata_and_parameterization_primary_datasets_2017.csv"

## metadata_and_parameterization_tuna_atlas_catch_datasets,metadata_and_parameterization_ird_tuna_atlas_nominal_catch_datasets : fill-in only if generate_and_load_global_tuna_atlas_datasets==TRUE
metadata_and_parameterization_tuna_atlas_catch_effort_datasets="https://raw.githubusercontent.com/ptaconet/rtunaatlas_scripts/master/tunaatlas_world/metadata_and_parameterization_files/metadata_and_parameterization_tuna_atlas_datasets_ird_2017.csv"
metadata_and_parameterization_tuna_atlas_nominal_catch_datasets="https://raw.githubusercontent.com/ptaconet/rtunaatlas_scripts/master/tunaatlas_world/metadata_and_parameterization_files/metadata_and_parameterization_tuna_atlas_nominal_catch_datasets_2017.csv"




repository_R_scripts="https://raw.githubusercontent.com/ptaconet/rtunaatlas_scripts/master/workflow_etl/scripts"  ## Repository where the scripts are stored
repository_sql_scripts="https://raw.githubusercontent.com/ptaconet/rtunaatlas_scripts/master/sql/deploy_database_model/"


if(!require(RPostgreSQL)){
  install.packages("RPostgreSQL")
}

if(!require(rtunaatlas)){
  if(!require(devtools)){
    install.packages("devtools")
  }
  require(devtools)
  install_github("ptaconet/rtunaatlas")
}
require(rtunaatlas)
require(RPostgreSQL)


# Source scripts
source("https://raw.githubusercontent.com/ptaconet/rtunaatlas_scripts/master/deploy_database_model.R") ## function to deploy the DB model
source(paste(repository_R_scripts,"open_dataset.R",sep="/"))
source(paste(repository_R_scripts,"generate_dataset.R",sep="/"))
source(paste(repository_R_scripts,"get_data_frame_code_lists.R",sep="/"))
source(paste(repository_R_scripts,"fill_missing_metadata.R",sep="/"))
source(paste(repository_R_scripts,"generate_tuna_atlas_identifier.R",sep="/"))
source(paste(repository_R_scripts,"push_R_script_to_server.R",sep="/"))
source(paste(repository_R_scripts,"workflow_tuna_atlas_dataset_to_load.R",sep="/"))
source(paste(repository_R_scripts,"workflow_tuna_atlas_dataset_to_generate_and_load.R",sep="/"))

## DB Connection parameters
con_parameters<-list(db_name=db_name,db_admin_name=db_admin_name,db_admin_password=db_admin_password,db_host=db_host)

## Main

if (deploy_database_model==TRUE){ ## Deploy the database model
  deploy_database_model_function(db_name,db_host,db_admin_name,db_read_name,db_admin_password,db_dimensions,db_variables_and_associated_dimensions,"https://raw.githubusercontent.com/ptaconet/rtunaatlas_scripts/master/sql/deploy_database_model")
}

if (load_codelists==TRUE){ 
  cat("Start loading the code lists and related metadata in the database...\n")
  # Open csv metadata of code lists
  table_metadata_and_parameterization<-read.csv(metadata_and_parameterization_csv_codelists,stringsAsFactors = F,colClasses = "character")
  # One by one, load the code lists  
  for (df_to_load in 1:nrow(table_metadata_and_parameterization)){
    metadata_and_parameterization<-table_metadata_and_parameterization[df_to_load,]
    workflow_tuna_atlas_dataset_to_load(con_parameters,metadata_and_parameterization)
  }
  cat("End loading the code lists and related metadata in the database\n")
}


if (load_codelists_mappings==TRUE){  ## Load the code lists mapping
  cat("Start loading the code lists mappings and related metadata in the database...\n")
  # Open csv metadata of code list mappings
  table_metadata_and_parameterization<-read.csv(metadata_and_parameterization_csv_mappings,stringsAsFactors = F,colClasses = "character")
  # One by one, load the code lists mappings
  for (df_to_load in 1:nrow(table_metadata_and_parameterization)){
    metadata_and_parameterization<-table_metadata_and_parameterization[df_to_load,]
    workflow_tuna_atlas_dataset_to_load(con_parameters,metadata_and_parameterization)
    cat("End loading the code lists mappings and related metadata in the database\n")
  }
}


if (transform_and_load_primary_datasets==TRUE){  ### Harmonize and load the primary datasets
  cat("Start harmonizing and loading the tRFMOs primary datasets and related metadata in the database...\n")
  # Open csv metadata of primary datasets and related parameterization
  table_metadata_and_parameterization<-read.csv(metadata_and_parameterization_csv_primary_datasets,stringsAsFactors = F,colClasses = "character")
  # One by one, load the primary datasets
  for (df_to_load in 1:nrow(table_metadata_and_parameterization)){
    metadata_and_parameterization<-table_metadata_and_parameterization[df_to_load,]
    metadata_and_parameterization$relation_source_dataset_persistent_url<-metadata_and_parameterization$parameter_path_to_raw_dataset
    workflow_tuna_atlas_dataset_to_generate_and_load(con_parameters,metadata_and_parameterization,year_tuna_atlas,vre_username,vre_token)
  }
  cat("End harmonizing and loading the tRFMOs primary datasets and related metadata in the database\n")
}


if (generate_and_load_global_tuna_atlas_datasets==TRUE){ ### Generate and load the global tuna atlas datasets
  
  # Open csv metadata of ird tuna atlas nomînal catch datasets and related parameterization
  table_metadata_and_parameterization<-read.csv(metadata_and_parameterization_tuna_atlas_nominal_catch_datasets,stringsAsFactors = F,colClasses = "character")
  # One by one, generate and load the ird tuna atlas datasets
  for (df_to_load in 1:nrow(table_metadata_and_parameterization)){
    metadata_and_parameterization<-table_metadata_and_parameterization[df_to_load,]
    workflow_tuna_atlas_dataset_to_generate_and_load(con_admin,metadata_and_parameterization,year_tuna_atlas,vre_username,vre_token)
  }
  cat("End generating and loading the global nominal catch tuna atlas datasets and related metadata in the database\n")
  
  cat("Start generating and loading the global tuna atlas datasets and related metadata in the database...\n")
  # Open csv metadata of ird tuna atlas catch datasets and related parameterization
  table_metadata_and_parameterization<-read.csv(metadata_and_parameterization_tuna_atlas_catch_effort_datasets,stringsAsFactors = F,colClasses = "character")
  # One by one, generate and load the ird tuna atlas datasets
  for (df_to_load in 1:nrow(table_metadata_and_parameterization)){
    metadata_and_parameterization<-table_metadata_and_parameterization[df_to_load,]
    workflow_tuna_atlas_dataset_to_generate_and_load(con_parameters,metadata_and_parameterization,year_tuna_atlas,vre_username,vre_token)
  }
  

}

