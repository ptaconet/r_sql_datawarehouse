get_data_frame_code_lists<-function(metadata_and_parameterization){
  df_codelists<-read.csv(metadata_and_parameterization$path_to_codelists_used_in_dataset)
  df_codelists<-data.frame(lapply(df_codelists, as.character), stringsAsFactors=FALSE)
  return(df_codelists)
}