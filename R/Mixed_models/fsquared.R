# Calculating the f-squared effect size
fsquared <- function(object_with,object_without){
  r2 <- r.squaredGLMM(object_with)[2]
  r1 <- r.squaredGLMM(object_without)[2]
  f_squared_value <- (r2^2 -r1^2)/(1-r2^2) 
  return(f_squared_value)
}
