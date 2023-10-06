# Testing lmer models under the hierarchichal assumption
lmer_chi_2_test <- function(object1,object2,df1,df2){
  summary_1 <- summary(object1)
  summary_2 <- summary(object2)
  Loglik1 <- as.numeric(summary_1$logLik)
  Loglik2 <- as.numeric(summary_2$logLik)
  TS <- -2*(Loglik1-Loglik2)
  p_value <- 0.5*(pchisq(TS,df=df1,lower.tail = FALSE))+0.5*(pchisq(TS,df=df2,lower.tail = FALSE))
  return(p_value)
}
