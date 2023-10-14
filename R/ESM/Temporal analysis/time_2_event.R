time_2_event <- function(data,event,time_variable,day_variable){
  time2event_list <-data.frame()
  event_row=nrow(data)
  for (row in nrow(data):1){
    if(as.numeric(data[row,][day_variable])==as.numeric(data[event_row,][day_variable])){
      time_diff <- as.numeric(difftime(as.POSIXct(as.numeric(data[row,][time_variable]),origin='1970-01-01'),
                                       as.POSIXct(as.numeric(data[event_row,][time_variable]),origin='1970-01-01'),units='mins'))
      if (time_diff)
        time2event_list[row,1] <- time_diff
    }
    else{
      time2event_list[row,1] <- 'NA'
    }
    if (is.na(data[row,][event])==FALSE){
      if (data[row,][event]==1){
        event_row = row
      }
    }
  }
  time2event_list[nrow(data),1] <- 'NA'
  time2event_list <- time2event_list %>% replace_with_na_all(condition = ~.x %in% c('NA'))
  time2event_list <- setNames(time2event_list,paste('time2_',event,sep=""))
  return(time2event_list)
}
