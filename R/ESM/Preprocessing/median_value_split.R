median_value_split <- function(data,value){
  median_value = median(data[value][,1],na.rm=TRUE)
  data_value = data[value]
  data_value[data_value[value]>=median_value]<-1
  data_value[data_value[value]<median_value]<-0
  data_value <- setNames(data_value,paste(value,'_median_group',sep=""))
  return(data_value)
}
