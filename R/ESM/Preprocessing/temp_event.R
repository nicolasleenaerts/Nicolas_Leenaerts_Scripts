# Making a dataset for a longitudinal ESM event analysis
temp_event <- function(data,variables,timepoints,constants){
  # Creating the dataframe that will have all the data
  temp_event_dataframe <- data.frame()
  for (event in 1:nrow(data)){
    for (timepoint in 1:length(timepoints)){
      temp_event_dataframe[(length(timepoints)*(event-1)+timepoint),1]<-timepoints[timepoint]
      for (variable in 1:length(variables)){
        if (timepoints[timepoint]<0){
          timepoint_string <- -timepoints[timepoint]
          variable_string <- paste(variables[variable],"_t_minus_",timepoint_string,sep="")
        }
        if (timepoints[timepoint]>0){
          timepoint_string <- timepoints[timepoint]
          variable_string <- paste(variables[variable],"_t_plus_",timepoint_string,sep="")
        }
        if (timepoints[timepoint]==0){
          variable_string <- variables[variable]
        }
        temp_event_dataframe[(length(timepoints)*(event-1)+timepoint),(1+variable)]<-data[variable_string][event,]
      }
      if (length(constants)>0){
        for (constant in 1:length(constants)){
          temp_event_dataframe[(length(timepoints)*(event-1)+timepoint),(1+length(variables)+constant)]<-data[constants[constant]][event,]
        }
      }
    }
  }
  col_names <- c("timepoints",variables,constants)
  temp_event_dataframe <- setNames(temp_event_dataframe,col_names)
  return(temp_event_dataframe)
}
