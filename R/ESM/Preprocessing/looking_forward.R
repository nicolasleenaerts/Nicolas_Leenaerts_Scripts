# Function to take the future timepoints of a certain value 
looking_forward <- function(data,parameter,signal_label,day_label,timepoints){
  # Creating the dataframe that bundles all the information
  timepoints_dataframe <- data.frame()
  # This loops over all the timepoints
  for (timepoint in 1:timepoints){
    # Looping over the rows of the data for each timepoint
    # This is expensive but allows for adaptability 
    for (row in 1:(nrow(data)-timepoint)){
      # Creating the label; that indicates that a previous timepoint was found
      found_label = FALSE
      # Checking if a previous datapoint falls under the criteria
      for (iteration in timepoint:1){
        if ((data[signal_label][row,1]+timepoint)==data[signal_label][(row+iteration),1]
            &data[day_label][row,1]==data[day_label][(row+iteration),1]){
          timepoints_dataframe[row,timepoint] = data[parameter][(row+iteration),1]
          found_label = TRUE
          break
        }
      }
      # If no timepoint is found, then NA is filled in
      if (found_label == FALSE){
        timepoints_dataframe[row,timepoint] = 'NA'
      }
    }
    # This labels the first entries as NA
    for (skip_number in 1:timepoint){
      timepoints_dataframe[row+skip_number,timepoint] = 'NA'
    }
  }
  col_names <- list()
  for (timepoint in 1:timepoints){
    col_names[timepoint] = paste0('_t_plus_',timepoint)
  }
  timepoints_dataframe <- setNames(timepoints_dataframe,paste0(parameter,col_names))
  timepoints_dataframe <- timepoints_dataframe %>% replace_with_na_all(condition = ~.x %in% c('NA'))
  return(timepoints_dataframe)
}
