zero_value_split <- function(data,value){
  data_value = data[value]
  data_value[data_value[value]>=0]<-1
  data_value[data_value[value]<0]<-0
  data_value <- setNames(data_value,paste(value,'_zero_group',sep=""))
  return(data_value)
}
