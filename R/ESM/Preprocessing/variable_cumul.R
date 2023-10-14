### Getting a variable that is the cumulative (continuous)
variable_cumul <- function(data,variable,day_variable){
  results <- data.frame()
  for (day in unlist(unique(data[day_variable]))){
    data_day = data[data[day_variable]==day,]
    cumulative =  NA
    na_rows = 0
    for (row in 1:nrow(data_day)){
      if (is.na(cumulative)==T){
        cumulative = as.numeric(as.character(data_day[variable][row,]))
        results[(nrow(results)+1),1] <- cumulative
      }
      else{
        if (is.na(data_day[variable][row,])==T){
          na_rows = na_rows+1
          results[(nrow(results)+1),1] <- NA
        }
        else{
          cumulative = cumulative+(na_rows+1)*as.numeric(as.character(data_day[variable][row,]))
          na_rows = 0
          results[(nrow(results)+1),1] <- cumulative
        }
      }
    }
  }
  results <- setNames(results,paste(variable,'_cumulative',sep=""))
  return(results)
}
