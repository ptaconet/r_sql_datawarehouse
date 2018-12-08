fill_missing_metadata<-function(metadata_file,additional_metadata){
  
  metadata_columns_input<-colnames(metadata_file)
  
  for (i in 1:length(metadata_columns_input)){
    this_metadata_element<-metadata_file[metadata_columns_input[i]][[1]]
    words_to_replace<-gsub("[\\%\\%]", "", regmatches(this_metadata_element, gregexpr("\\%.*?\\%", this_metadata_element))[[1]])
    if (length(words_to_replace)>0){
      for (j in 1:length(words_to_replace)){
        if (words_to_replace[j] %in% names(additional_metadata)){
          metadata_file[metadata_columns_input[i]]<-gsub(paste0("%",words_to_replace[j],"%"),as.character(additional_metadata[words_to_replace[j]]),metadata_file[metadata_columns_input[i]][[1]])
        }
      }
    }
  }
  
  return(metadata_file) 
}
  