# This function calculates the minimum, maximum and difference for a parameter
min_max_diff_day <- function(data,variable,participant_label,day_label){
  # Creating the necessary lists
  minimum <- list()
  maximum <- list()
  difference <- list()
  counter = 0
  # looping over the participants
  for (participant_row in 1:nrow(unique(data[participant_label]))){
    # Creating a specific dataset for each participant
    participant = as.integer(unique(data[participant_label])[participant_row,])
    data_participant <- subset(data,data[participant_label] == participant)
      # Looping over the days of a participant
      for (day_row in 1:nrow(unique(data_participant[day_label]))){
        # Creating a specific dataset for each day
        day = as.integer(unique(data_participant[day_label])[day_row,])
        data_day <- subset(data_participant,data_participant[day_label]==day)
        # filtering out the na's 
        data_day_not_na <- subset(data_day,is.na(data_day[variable]) == FALSE)
        # Seeing if the dataframe if not empty
        if (nrow(data_day_not_na) > 0){
          min <- min(data_day_not_na[variable])
          max <- max(data_day_not_na[variable])
          diff <- max - min
        }
        else{
          min <- NA
          max <- NA
          diff <- NA
        }
        # Adding the values to the lists
        for (row in 1:nrow(data_day)){
          counter = counter + 1
          minimum[counter] = min
          maximum[counter] = max
          difference[counter] = diff
        }
      }
  }
  min_max_diff_dataframe <- data.frame(minimum = unlist(minimum),maximum = unlist(maximum),
                                       difference = unlist(difference))
  col_names <- c('_minimum','_maximum','_difference')
  min_max_diff_dataframe <- setNames(min_max_diff_dataframe,paste0(variable,col_names))
  return(min_max_diff_dataframe)
}
  
