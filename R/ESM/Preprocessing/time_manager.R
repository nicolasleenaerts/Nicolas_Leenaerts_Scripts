# labeling signals, days, weeks, bursts
time_manager <- function(data,participant_label,time_label,calculate_signals_total=TRUE,calculate_signals_day=TRUE,
                         calculate_days_total=TRUE,week_length=3,calculate_days_per_week = TRUE, calculate_weeks_total=TRUE,
                         burst_amount=7,burst_length = 3){
  # Creating the dataframe that will keep all the information
  time_dataframe <- data_frame()
  # Creating a counter for the signals total rows
  signals_total_entry = 0
  # Creating a counter for the signals per day, days total rows
  sig_day_burst_row_entry = 0
  # Looping over the participants
  for (row in 1:nrow(unique(data[participant_label]))){
    # Creating a counter so that not every time_variable needs to be included
    column_counter = 0
    # Labeling all signals per participant
    if (calculate_signals_total == TRUE){
      column_counter = column_counter + 1
      for (signal in 1:table(data[participant_label])[row]){
        signals_total_entry = signals_total_entry + 1
        time_dataframe[signals_total_entry,column_counter] = signal
      }
    }
    # Labeling, signals per day, days, bursts
    if (calculate_signals_day==TRUE|calculate_days_total==TRUE|calculate_weeks_total==TRUE){
      # Making a table of all the days and the signals per participant
      table_days_participant <- table(lapply(subset(data,data[participant_label] == 
                                                      as.integer(unique(data[participant_label])[row,]))[time_label],as.Date))
      # Making a list of all the weeks in the study assuming an equal distribution of the signals in the weeks
      if (calculate_weeks_total == TRUE|calculate_days_per_week == TRUE){
        week_list_participant <- list()
        day_per_week_list_participant <- list()
        week_list_participant_entry = 0
        for (table_row in 1:(nrow(table_days_participant)/week_length)){
          for (length in 1:week_length){
            week_list_participant_entry = week_list_participant_entry + 1
            week_list_participant[week_list_participant_entry] = table_row
            day_per_week_list_participant[week_list_participant_entry] = length
          }
        }
      }
      # Looping through the days
      for (table_row in 1:nrow(table_days_participant)){
        # Looping through the entries per day
        for (signal in 1:table_days_participant[table_row]){
          sig_day_burst_row_entry = sig_day_burst_row_entry + 1
          dataframe_entries = 0
          # Adding the signals per day
          if (calculate_signals_day==TRUE){
            column_counter = column_counter + 1
            dataframe_entries = dataframe_entries + 1
            time_dataframe[sig_day_burst_row_entry,column_counter] = signal
          }
          # Adding the days total
          if (calculate_days_total==TRUE){
            column_counter = column_counter + 1
            dataframe_entries = dataframe_entries + 1
            time_dataframe[sig_day_burst_row_entry,column_counter] = table_row
          }
          # Adding days per week
          if (calculate_days_per_week==TRUE){
            column_counter = column_counter + 1
            dataframe_entries = dataframe_entries + 1
            time_dataframe[sig_day_burst_row_entry,column_counter] = day_per_week_list_participant[table_row]
          }
          # Adding the weeks total
          if (calculate_weeks_total==TRUE){
            column_counter = column_counter + 1
            dataframe_entries = dataframe_entries + 1
            time_dataframe[sig_day_burst_row_entry,column_counter] = week_list_participant[table_row]
          }
          column_counter =  column_counter - dataframe_entries
        }
      }
    }
  }
  return(final_dataframe)
}
