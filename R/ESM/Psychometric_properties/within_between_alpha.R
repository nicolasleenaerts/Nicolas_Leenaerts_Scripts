within_between_alpha <- function(data,participant){
  # Load libraries
  require(psych)
  require(alpha)
  
  # Get between-person alpha
  between_person_alpha = alpha(as.data.frame(lapply(select(data,-participant),as.numeric)),check.keys=TRUE)$total
  
  # Get within-person alpha
  within_person_alphas = apply(unique(data[participant]),1,function(x){
    select(subset(data,data[participant]==x),-participant)
    alpha(as.data.frame(lapply(select(subset(data,data[participant]==x),-participant),as.numeric)),check.keys=TRUE)$total
  })
  
  # Create results
  results = data.frame(matrix(nrow=3,ncol=length(between_person_alpha)+1))
  colnames(results) = c('type',colnames(between_person_alpha))
  
  # Store results
  results$type = c('between_person','within_person_mean','within_person_median')
  results[1,2:(length(between_person_alpha)+1)] = between_person_alpha
  results[2,2:(length(between_person_alpha)+1)] = apply(bind_rows(within_person_alphas),2,function(x) mean(x,na.rm=T))
  results[3,2:(length(between_person_alpha)+1)] = apply(bind_rows(within_person_alphas),2,function(x) median(x,na.rm=T))
  
  # Return results
  return(results)
}
