# Numbering the events on a day
number_event_day <- function(data,event_variable,day_variable){
  output <- data.frame()
  for (element in 1:nrow(unique(data[day_variable]))){
    day = unique(data[day_variable])[element,]
    data_day <- data[which(data[day_variable]==day),]
    if (sum(is.na(data_day[event_variable]))/length(data_day[event_variable])<1){
      if (any(1==na.omit(data_day[event_variable]))==TRUE){
        event_counter = 0
        event_number_list = c()
        for(row in 1:nrow(data_day)){
          if (data_day[event_variable][row,]==1){
            event_counter=event_counter+1
            event_number_list[row] <- event_counter
          }
          else{
            event_number_list[row] <- 0
          }
        }
        output[(nrow(output)+1):(nrow(output)+length(event_number_list)),1] <-event_number_list
      }
      else{
        output[(nrow(output)+1):(nrow(output)+nrow(data_day)),1] <-rep(0, (nrow(data_day)))
      }
    }
    else{
      output[(nrow(output)+1):(nrow(output)+nrow(data_day)),1] <-rep(0, (nrow(data_day)))
    }
  }
  output <- setNames(output,paste(event_variable,'_number',sep=""))
  return(output)
}
