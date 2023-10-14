# Testing lmer models under the hierarchichal assumption here you put in the values yourself
lmer_chi_2_test_manual <- function(Loglik1,Loglik2,df1,df2){
  TS <- -2*(Loglik1-Loglik2)
  p_value <- 0.5*(pchisq(TS,df=df1,lower.tail = FALSE))+0.5*(pchisq(TS,df=df2,lower.tail = FALSE))
  return(p_value)
}
