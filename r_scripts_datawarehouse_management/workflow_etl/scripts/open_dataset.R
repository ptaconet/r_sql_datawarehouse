## Open a dataset to load as R data.frame

open_dataset<-function(metadata_and_parameterization){
  
  # If the dataset is remote (ie stored on internet), download it locally to avoid errors when reading the dataset
  if (substr(metadata_and_parameterization$path_to_dataset,1,4)=="http"){
  cat(paste0("Downloading the file locally...\n"))
  file_name<-Sys.time()
  file_name<-gsub("-","_",Sys.time())
  file_name<-gsub(" ","_",file_name)
  file_name<-gsub(":","_",file_name)
  download.file(metadata_and_parameterization$path_to_dataset,paste0(getwd(),"/",file_name,".csv"))
  metadata_and_parameterization$path_to_dataset<-paste0(getwd(),"/",file_name,".csv")
  cat(paste0("END downloading the file locally\n"))
  
}

# Read the file. All the columns are read as characters
cat(paste0("Reading the file...\n"))
dataset<-read.csv(metadata_and_parameterization$path_to_dataset,stringsAsFactors = FALSE,colClasses="character")
file.remove(paste0(getwd(),"/",file_name,".csv"))

  return(dataset)
  
}