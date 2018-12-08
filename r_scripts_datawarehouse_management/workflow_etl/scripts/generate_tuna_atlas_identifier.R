
generate_tuna_atlas_identifier<-function(metadata_and_parameterization,dataset,year_tuna_atlas){
  
### identifier
dataset_time_start<-as.character(min(as.Date(dataset$time_start)))
dataset_time_end<-as.character(max(as.Date(dataset$time_end)))
identifier<-metadata_and_parameterization$persistent_identifier
identifier<-gsub("tunaatlas",paste(dataset_time_start,dataset_time_end,"tunaatlas",sep="_"),identifier)
#identifier<-gsub("level",paste0(year_tuna_atlas,"_level"),identifier)
identifier<-paste(identifier,year_tuna_atlas,sep="__")
identifier<-gsub("-","_",identifier)

return(identifier)

}