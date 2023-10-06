# Standardising the coefficients for clmm
stdCoefclmm <- function(object,parameter) {
  sdy <- sd(unlist(object['fitted.values']))
  sdx <- apply(as.data.frame(object['model']), 2, sd)
  coefficients_parameter_string <- paste('coefficients',parameter,sep='.')
  model_parameter_string <- paste('model',parameter,sep='.')
  sdx_parameter <- sdx[model_parameter_string]
  coefficient <- unlist(object['coefficients'])[coefficients_parameter_string]
  sc <- coefficient*sdx_parameter/sdy
  se.fixef <- coef(summary(object))[,"Std. Error"][parameter]
  se <- se.fixef*sdx_parameter/sdy
  return(data.frame(stdcoef=sc, stdse=se))
}
