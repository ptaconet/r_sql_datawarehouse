######################################################################
##### 52North WPS annotations ##########
######################################################################
# wps.des: id = deploy_database_model, title = Deploy a database on a PostgreSQL+PostGIS server, abstract = Customize the deployement of a database on a server. Prerequisites: A PostgreSQL + PostGIS model must be installed on a server. There must be an admin user and a user with select privileges. ;
# wps.in: id = db_name, type = string, title = Name of the database. , value = "tunaatlas";
# wps.in: id = db_host, type = string, title = Host server for the database. , value = "db-tuna.d4science.org";
# wps.in: id = db_admin_name, type = string, title = Name of the administrator role. , value = "tunaatlas_u";
# wps.in: id = db_read_name, type = string, title = Name of the user role with select privileges. , value = "invsardara";
# wps.in: id = db_admin_password, type = string, title = Password for administrator role of the database. , value = "****";
# wps.in: id = db_dimensions, type = string, title = Name of the dimensions to deploy. The dimensions must be separated by a comma. , value = "area,catchtype,unit,flag,gear,schooltype,sex,sizeclass,species,time,source";
# wps.in: id = db_variables_and_associated_dimensions, type = string, title = Name of the variables to deploy and their associated dimensions. The format is: variable_name=list_of_dimensions_associated_separated_by_commas. The variables should be separated by the symbol '@'. , value = "catch=schooltype,species,time,area,gear,flag,catchtype,unit,source@effort=schooltype,time,area,gear,flag,unit,source@catch_at_size=schooltype,species,time,area,gear,flag,catchtype,sex,unit,sizeclass,source";
# wps.in: id = repository_sql_scripts_database_deployement, type = string, title = Folder where the scripts to deploy database are available , value = "https://raw.githubusercontent.com/ptaconet/rtunaatlas_scripts/master/sql/deploy_database_model/";


deploy_database_model_function<-function(db_name,db_host,db_admin_name,db_read_name,db_admin_password,db_dimensions,db_variables_and_associated_dimensions,repository_sql_scripts_database_deployement){

cat("Starting deployement of the database!\n")


if(!require(RPostgreSQL)){
  install.packages("RPostgreSQL")
}
require(RPostgreSQL)


# Connect to db with admin rights
drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv, dbname=db_name, user=db_admin_name, password=db_admin_password, host=db_host)

# Preliminary step: grant select on all objects of the DB to the user with select privileges
dbSendQuery(con,paste0("alter default privileges grant select on tables to \"",db_read_name,"\""))

## 1) Deploy schema metadata and associated tables

cat(paste0("Deploying schema metadata and tables...\n"))
# Read SQL query
fileName <- paste(repository_sql_scripts_database_deployement,"create_schema_metadata.sql",sep="/")
sql_deploy_metadata<-paste(readLines(fileName), collapse="\n")
sql_deploy_metadata<-gsub("%db_admin%",db_admin_name,sql_deploy_metadata)
sql_deploy_metadata<-gsub("%db_read%",db_read_name,sql_deploy_metadata)

dbSendQuery(con,sql_deploy_metadata)

cat(paste0("END deploying schema metadata and tables\n"))

## 2) Deploy dimensions

# Create vector of dimensions to deploy
dimensions<-strsplit(db_dimensions, ",")[[1]]

# One by one, create the dimensions
for (i in 1:length(dimensions)){
  cat(paste0("Deploying dimension ",dimensions[i],"...\n"))
  
  if (dimensions[i]=="time"){
    fileName <- paste(repository_sql_scripts_database_deployement,"create_schema_dimension_time.sql",sep="/")
  } else if (dimensions[i]=="sizeclass"){
    fileName <- paste(repository_sql_scripts_database_deployement,"create_schema_dimension_sizeclass.sql",sep="/")
  } else {
    fileName <- paste(repository_sql_scripts_database_deployement,"create_schema_dimension.sql",sep="/")
  }
  
  sql_deploy_dimension<-paste(readLines(fileName), collapse="\n")
  sql_deploy_dimension<-gsub("%db_admin%",db_admin_name,sql_deploy_dimension)
  sql_deploy_dimension<-gsub("%dimension_name%",dimensions[i],sql_deploy_dimension)
  sql_deploy_dimension<-gsub("%db_read%",db_read_name,sql_deploy_dimension)
  
  dbSendQuery(con,sql_deploy_dimension)
  
  if (dimensions[i]=="area"){
    # Create table area.area_wkt
    sql_deploy_table_area_wkt<-paste(readLines(paste(repository_sql_scripts_database_deployement,"create_table_area_wkt.sql",sep="/")), collapse="\n")
    sql_deploy_table_area_wkt<-gsub("%db_admin%",db_admin_name,sql_deploy_table_area_wkt)
    dbSendQuery(con,sql_deploy_table_area_wkt)
    dbSendQuery(con,"COMMENT ON SCHEMA area IS 'Schema containing the spatial code lists (i.e. reference data) (including the PostGIS geometries) used in the datasets'")
    
    # Update view area.area_labels
    sql_deploy_view_area_labels<-paste(readLines(paste(repository_sql_scripts_database_deployement,"create_view_area_labels.sql",sep="/")), collapse="\n")
    sql_deploy_view_area_labels<-gsub("%db_admin%",db_admin_name,sql_deploy_view_area_labels)
    dbSendQuery(con,sql_deploy_view_area_labels)
    
  }
  
  cat(paste0("END deploying dimension ",dimensions[i],"\n"))
  
}


## 3) Deploy variable tables

facts<-strsplit(db_variables_and_associated_dimensions, "@")[[1]]

for (i in 1:length(facts)){
  
  fact_name<-sub('=.*', '', facts[i])
  dimensions_for_fact<-strsplit(sub('.*=', '', facts[i]),",")[[1]]

  cat(paste0("Deploying variable ",fact_name," with associated dimensions...\n"))
  
  sql_deploy_fact_table<-paste0("CREATE TABLE fact_tables.",fact_name,"(
                               id_",fact_name," SERIAL PRIMARY KEY,
                               id_metadata INTEGER REFERENCES metadata.metadata(id_metadata),")
  
  for (j in 1:length(dimensions_for_fact)){
    sql_deploy_fact_table<-paste0(sql_deploy_fact_table,"id_",dimensions_for_fact[j], " INTEGER REFERENCES ",dimensions_for_fact[j],".",dimensions_for_fact[j],"(id_",dimensions_for_fact[j],"),")
  }
  
  sql_deploy_fact_table<-paste0(sql_deploy_fact_table,"value numeric(12,2) NOT NULL);ALTER TABLE metadata.metadata
  OWNER TO \"",db_admin_name,"\";
GRANT ALL ON TABLE fact_tables.",fact_name," TO \"",db_admin_name,"\";

CREATE INDEX id_metadata_",fact_name,"_idx
  ON fact_tables.",fact_name,"
  USING btree
  (id_metadata);")
  
  dbSendQuery(con,sql_deploy_fact_table)
  
  sql_deploy_fact_table<-NULL
  
  cat(paste0("END Deploying fact table ",fact_name," with associated dimensions\n"))
  
}
  

dbDisconnect(con)

cat("The database has been deployed!\n")

}
