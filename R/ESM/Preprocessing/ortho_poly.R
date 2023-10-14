ortho_poly <- function(data,variable,degree=3){
  # Creating a variable
  data_variable <- data[variable]
  # Calculating the polynomials
  poly <- poly(as.numeric(data_variable[is.na(data_variable)==FALSE]),degree)
  numbers <- row_number(data_variable[is.na(data_variable)==FALSE])
  # Creating the polynomial variables 
  variable_names <- c()
  for (polynomial in 1:degree){
    data[paste(variable,'polynomial',polynomial,sep="_")] <- data_variable
    # Replacing the original values with the polynomial
    data[paste(variable,'polynomial',polynomial,sep="_")][row_number(data[paste(variable,'polynomial',polynomial,sep="_")])%in%c(numbers),]<-poly[,polynomial]
    variable_names[length(variable_names)+1]<-paste(variable,'polynomial',polynomial,sep="_")
  }
  output <- subset(data[variable_names])
  return(output)
}
