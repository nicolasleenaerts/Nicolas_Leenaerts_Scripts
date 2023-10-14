
ortho_poly_time <- function(data,time_variable,degree=3,include_zero=FALSE){
  # Reating the before and after time variables
  data[paste(time_variable,'before',sep="_")] <- data[time_variable]
  data[paste(time_variable,'after',sep="_")] <- data[time_variable]
  # Creating NA values
  data[paste(time_variable,'before',sep="_")][data[time_variable]>=0] <- -99999
  if (include_zero==TRUE){
    data[paste(time_variable,'after',sep="_")][data[time_variable]<0] <- -99999
  }
  else{
    data[paste(time_variable,'after',sep="_")][data[time_variable]<=0] <- -99999
  }
  data[paste(time_variable,'before',sep="_")] <- data[paste(time_variable,'before',sep="_")] %>% replace_with_na_all(condition = ~.x %in% c(-99999))
  data[paste(time_variable,'after',sep="_")] <- data[paste(time_variable,'after',sep="_")] %>% replace_with_na_all(condition = ~.x %in% c(-99999))
  # Calculating the polynomials
  poly_before <- poly(as.numeric(data[paste(time_variable,'before',sep="_")][is.na(data[paste(time_variable,'before',sep="_")])==FALSE]),degree)
  poly_after <- poly(as.numeric(data[paste(time_variable,'after',sep="_")][is.na(data[paste(time_variable,'after',sep="_")])==FALSE]),degree)
  numbers_before <- row_number(data[paste(time_variable,'before',sep="_")][is.na(data[paste(time_variable,'before',sep="_")])==FALSE])
  numbers_after <- row_number(data[paste(time_variable,'after',sep="_")][is.na(data[paste(time_variable,'after',sep="_")])==FALSE])
  # Creating the polynomial variables 
  variable_names <- c()
  for (polynomial in 1:degree){
    data[paste(time_variable,'before',polynomial,sep="_")] <- data[paste(time_variable,'before',sep="_")]
    data[paste(time_variable,'after',polynomial,sep="_")] <- data[paste(time_variable,'after',sep="_")]
    # Replacing the original values with the polynomial
    # variable <- c(data[paste(time_variable,'before',polynomial,sep="_")])
    data[paste(time_variable,'before',polynomial,sep="_")][row_number(data[paste(time_variable,'before',polynomial,sep="_")])%in%c(numbers_before),]<-poly_before[,polynomial]
    data[paste(time_variable,'after',polynomial,sep="_")][row_number(data[paste(time_variable,'after',polynomial,sep="_")])%in%c(numbers_after),]<-poly_after[,polynomial]
    # Making a combined variable
    data[paste(time_variable,'polynomial',polynomial,sep="_")] <- rowMeans(cbind(data[paste(time_variable,'before',polynomial,sep="_")],data[paste(time_variable,'after',polynomial,sep="_")]),na.rm = TRUE)
    variable_names[length(variable_names)+1]<-paste(time_variable,'before',polynomial,sep="_")
    variable_names[length(variable_names)+1]<-paste(time_variable,'after',polynomial,sep="_")
    variable_names[length(variable_names)+1]<-paste(time_variable,'polynomial',polynomial,sep="_")
  }
  output <- subset(data[variable_names])
  return(output)
}
