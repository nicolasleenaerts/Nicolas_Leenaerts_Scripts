time_after_event <- function(data,event,time_variable,day_variable){
  time_after_list <-data.frame()
  event_row=1
  for (row in 1:nrow(data)){
    if(as.numeric(data[row,][day_variable])==as.numeric(data[event_row,][day_variable])){
      time_diff <- as.numeric(difftime(as.POSIXct(as.numeric(data[row,][time_variable]),origin='1970-01-01'),
                                             as.POSIXct(as.numeric(data[event_row,][time_variable]),origin='1970-01-01'),units='mins'))
      if (time_diff)
        time_after_list[row,1] <- time_diff
    }
    else{
      time_after_list[row,1] <- 'NA'
    }
    if (is.na(data[row,][event])==FALSE){
      if (data[row,][event]==1){
        event_row = row
      }
    }
  }
  time_after_list[1,1] <- 'NA'
  time_after_list <- time_after_list %>% replace_with_na_all(condition = ~.x %in% c('NA'))
  time_after_list <- setNames(time_after_list,paste('time_after_',event,sep=""))
  return(time_after_list)
}
