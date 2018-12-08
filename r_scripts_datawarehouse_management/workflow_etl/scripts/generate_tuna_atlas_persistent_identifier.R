generate_tuna_atlas_persistent_identifier<-function(metadata_and_parameterization,fact){
  
  # Get input parameters names and values
  parameters_columns<-colnames(metadata_and_parameterization)[which(grepl("parameter_",colnames(metadata_and_parameterization)))]
  for (i in 1:length(parameters_columns)){
    assign(gsub("parameter_","",parameters_columns[i]), metadata_and_parameterization[,parameters_columns[i]],envir=.GlobalEnv)
  }
  
  ## spatialcoverage
  spatialcoverage_identifier<-NULL
  spatialcoverage_view<-NULL
  if (include_IOTC=="TRUE") {
    spatialcoverage_identifier=c(spatialcoverage_identifier,"indian")
    spatialcoverage_view=c(spatialcoverage_view,"ind")
  }
  if (include_ICCAT=="TRUE") {
    spatialcoverage_identifier=c(spatialcoverage_identifier,"atlantic")
    spatialcoverage_view=c(spatialcoverage_view,"atl")
  }
  if (include_IATTC=="TRUE") {
    spatialcoverage_identifier=c(spatialcoverage_identifier,"east_pacific")
    spatialcoverage_view=c(spatialcoverage_view,"eop")
  }
  if (include_WCPFC=="TRUE") {
    spatialcoverage_identifier=c(spatialcoverage_identifier,"west_pacific")
    spatialcoverage_view=c(spatialcoverage_view,"wpo")
  }
  if (include_CCSBT=="TRUE") {
    spatialcoverage_identifier=c(spatialcoverage_identifier,"southern_hemispheres")
    spatialcoverage_view=c(spatialcoverage_view,"soh")
  }
  
  spatialcoverage_identifier<-paste(spatialcoverage_identifier,sep="",collapse="_")
  spatialcoverage_identifier<-paste(spatialcoverage_identifier,"ocean",sep="_")
  
  spatialcoverage_view<-paste(spatialcoverage_view,sep="",collapse="_")

  if (include_IOTC=="TRUE" && include_ICCAT=="TRUE" && include_IATTC=="TRUE" && include_WCPFC=="TRUE" && include_CCSBT=="TRUE"){
    spatialcoverage_identifier="global"
    spatialcoverage_view="global"
  } 
  
  if (fact!="nominal_catch"){
  ## spatial resolution
  if (aggregate_on_5deg_data_with_resolution_inferior_to_5deg=="TRUE" && disaggregate_on_5deg_data_with_resolution_superior_to_5deg %in% c("disaggregate","remove")){
    spatialresolution="5deg"
  } else if (disaggregate_on_1deg_data_with_resolution_superior_to_1deg %in% c("disaggregate","remove")){
    spatialresolution="1deg"
  } else {
    spatialresolution<-""
  }
  
  ## temporal resolution
  temporalresolution="1m"
  
  ## level
  if (unit_conversion_convert=="FALSE" && spatial_curation_data_mislocated %in% c("no_reallocation","remove") && raising_georef_to_nominal=="FALSE") {
    level<-"level0"
  } else if (unit_conversion_convert=="TRUE" && spatial_curation_data_mislocated=="reallocate" && raising_georef_to_nominal=="FALSE"){
    level<-"level1"
  } else if (unit_conversion_convert=="TRUE" && spatial_curation_data_mislocated=="reallocate" && raising_georef_to_nominal=="TRUE"){
    level<-"level2"
  } else {
    level<-"other"
  }
  
  
  } else {
    spatialresolution<-""
    temporalresolution=""
    level<-"other"
  }
  
  ## source
  source<-paste0("tunaatlas",tolower(metadata_and_parameterization$source))
  
  
  ## generate persistent identifier and database view name
  persistent_identifier<-paste(spatialcoverage_identifier,fact,spatialresolution,temporalresolution,source,level,sep="_")
  persistent_identifier<-gsub("__","_",persistent_identifier)
  persistent_identifier<-gsub(paste(source,"other",sep="_"),source,persistent_identifier)

  database_view_name<-paste(spatialcoverage_view,fact,spatialresolution,temporalresolution,source,level,sep="_")
  database_view_name<-paste0("tunaatlas_",tolower(metadata_and_parameterization$source),".",database_view_name)
  database_view_name<-gsub("__","_",database_view_name)
  database_view_name<-gsub(paste(source,"other",sep="_"),source,database_view_name)
  
  return(list(persistent_identifier=persistent_identifier,database_view_name=database_view_name))
  
}