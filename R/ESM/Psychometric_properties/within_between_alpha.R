within_between_alpha <- function(data,participant){
  # Load libraries
  require(psych)
  require(dplyr)
  
  # Get total data alpha (no averaging data for each participant)
  total_alpha = alpha(as.data.frame(lapply(select(data,-participant),as.numeric)),check.keys=F)$total
  
  # Get between-person alpha (after data is averaged for each participant)
  between_person_alpha = alpha(as.data.frame(select(aggregate(lapply(select(data,-participant),as.numeric),by=data[participant],mean,na.rm=T),-participant)),check.keys=F)$total
  
  # Get within-person alpha
  within_person_alphas = apply(unique(data[participant]),1,function(x){
    select(subset(data,data[participant]==x),-participant)
    alpha(as.data.frame(lapply(select(subset(data,data[participant]==x),-participant),as.numeric)),check.keys=F)$total
  })
  
  # Create results
  results = data.frame(matrix(nrow=4,ncol=length(between_person_alpha)+1))
  colnames(results) = c('type',colnames(between_person_alpha))
  
  # Store results
  results$type = c('total','between_person','within_person_mean','within_person_median')
  results[1,2:(length(between_person_alpha)+1)] = total_alpha
  results[2,2:(length(between_person_alpha)+1)] = between_person_alpha
  results[3,2:(length(between_person_alpha)+1)] = apply(bind_rows(within_person_alphas),2,function(x) mean(x,na.rm=T))
  results[4,2:(length(between_person_alpha)+1)] = apply(bind_rows(within_person_alphas),2,function(x) median(x,na.rm=T))
  
  # Return results
  return(results)
}

#### EXAMPLE ####

# Negative affect
negative_affect_data <- my_data_ml[,c('Participant','affect_angstig','affect_eenzaam','affect_gestrest','affect_schuldig','affect_somber','affect_onzeker')]
alpha_na <- within_between_alpha(negative_affect_data,'Participant')
                                                        
