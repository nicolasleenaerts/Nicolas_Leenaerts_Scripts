# Function to create non-orthogonal polynomials
add_polnomials <-function(data,variable,degree=3){
  # Creating the dataframe of the polynomials
  polynomials_dataframe <- data.frame()
  # Looping over the degrees
  for (i in 2:degree){
    # Creating the new polynomial
    new_polynomial <- data[variable]^i
    names(new_polynomial) <- paste(variable,'_',i,sep='')
    # Adding the created polynomial to the dataframe of the polynomials
    if (length(polynomials_dataframe) == 0){
      polynomials_dataframe <- new_polynomial
    }
    else {
      polynomials_dataframe <- cbind(polynomials_dataframe,new_polynomial)
    }
  }
  # Returning the dataframe with the polynomials
  return(polynomials_dataframe)
}
