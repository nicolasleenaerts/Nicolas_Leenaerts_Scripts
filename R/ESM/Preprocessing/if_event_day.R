# Seeing if an event happens on a day of not
if_event_day <- function(data,event_variable,day_variable){
  output <- data.frame()
  for (element in 1:nrow(unique(data[day_variable]))){
    day = unique(data[day_variable])[element,]
    data_day <- data[which(data[day_variable]==day),]
    if (all(is.na(data_day[event_variable]))==FALSE){
      if (any(1==na.omit(data_day[event_variable]))==TRUE){
        output[(nrow(output)+1):(nrow(output)+nrow(data_day)),1] <- rep(1, (nrow(data_day)))
      }
      else{
        output[(nrow(output)+1):(nrow(output)+nrow(data_day)),1] <-rep(0, (nrow(data_day)))
      }
    }
    else{
      output[(nrow(output)+1):(nrow(output)+nrow(data_day)),1] <-rep(0, (nrow(data_day)))
    }
  }
  output <- setNames(output,paste(event_variable,'_day',sep=""))
  return(output)
}
