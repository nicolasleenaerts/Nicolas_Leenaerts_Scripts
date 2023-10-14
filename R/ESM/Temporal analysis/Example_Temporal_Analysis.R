source(file = 'R_nicolas_functions.R')
# Calculating the previous and next binge drinking variables
bd_t_minus_1 <- looking_back(my_data,'binge_drinking','signals_per_day','days_total_list',1)
bd_t_plus_1 <- looking_forward(my_data,'binge_drinking','signals_per_day','days_total_list',1)
my_data<-cbind(my_data,bd_t_minus_1,bd_t_plus_1)

#Calculating the binge drinking day and number
binge_drinking_day <- if_event_day(my_data,'binge_drinking','days_total_list')
binge_drinking_number <- number_event_day(my_data,'binge_drinking','days_total_list')
my_data<-cbind(my_data,binge_drinking_number,binge_drinking_day)

#Calculating the alcohol before event
binge_drinking_hoeveelheid_t_minus_1 <- looking_back(my_data,'binge_drinking_hoeveelheid','signals_per_day','days_total_list',7)
binge_drinking_hoeveelheid_t_plus_1 <- looking_forward(my_data,'binge_drinking_hoeveelheid','signals_per_day','days_total_list',7)
my_data<-cbind(my_data,binge_drinking_hoeveelheid_t_minus_1,binge_drinking_hoeveelheid_t_plus_1)

# Subsetting the data
my_data_subset_group <- subset(my_data,my_data$Group %in% c('AUD','BNAUD'))

# Time before binge
time2binge_drinking <- time_2_event(my_data_subset_group,'binge_drinking','absolute_time','days_total_list')
my_data_subset_group <- cbind(my_data_subset_group,time2binge_drinking)

# Taking only the first binge drinking episode
my_data_subset_group <- subset(my_data_subset_group,my_data_subset_group$binge_drinking==1)
my_data_subset_group <- subset(my_data_subset_group,my_data_subset_group$signal_number_day!=1)
my_data_subset_group <- subset(my_data_subset_group,my_data_subset_group$binge_drinking_number==1)

# data_frame_binges <- as.data.frame(table(my_data_subset_group$days_total_list))
# days_with_one_binge <- unfactor(data_frame_binges$Var1[data_frame_binges$Freq==1])
# my_data_subset_group <- subset(my_data_subset_group,my_data_subset_group$days_total_list%in%c(days_with_one_binge))

# #Adding the allocations
# my_data_subset_group <- subset(my_data_subset_group,days_total_list %in% clustering_data_subset_wide$days_total_list)
#  my_data_subset_group$cluster <-  as.data.frame(final_allocations)

# Converting dataset to long type
my_data_subset_group$absolute_time_binge <- my_data_subset_group$absolute_time
hours_dataset_long <- temp_event(my_data_subset_group,c("stress_deviation","na_deviation","pa_deviation",'impulsivity','negative_affect',
                                                        "impulsivity_deviation","craving_alcohol_deviation","absolute_time",'binge_drinking_hoeveelheid'),
                                 timepoints = c(-7,-6,-5,-4,-3,-2,-1,0,1,2,3,4,5,6,7),constants=c("Participant","absolute_time_binge","days_total_list","blocks_total_list","bursts_total_list",'mean_craving_alcohol_participant',
                                                                                                  'mean_impulsivity_participant','mean_na_participant','mean_pa_participant','mean_stress_participant','Group','time2_binge_drinking',
                                                                                                  'Age','BMI'))
#Calculating the difference between the time of the signal and the time of the binge eating episode
hours_dataset_long$minutes_difference <- as.numeric(difftime(as.POSIXct(as.numeric(hours_dataset_long$absolute_time),origin='1970-01-01'),as.POSIXct(hours_dataset_long$absolute_time_binge,origin='1970-01-01'))/60)

#Deleting the rest from the environment
#keep(my_data,my_data_copy,hours_dataset_long,sure=TRUE)

# Removing signals in be episode in 4 hours after the first one
hours_dataset_long$time2_binge_drinking <- -1*as.numeric(hours_dataset_long$time2_binge_drinking)
hours_dataset_long <- subset(hours_dataset_long,is.na(time2_binge_drinking)==TRUE|minutes_difference<time2_binge_drinking)


## PLOTTING THE DATA
hours_dataset_long_plot<- subset(hours_dataset_long,minutes_difference>-240&minutes_difference<(240))
hours_dataset_long_plot$estimated <- 'Original'
p1<-ggplot(hours_dataset_long_plot,aes(x=as.numeric(minutes_difference),y=as.numeric(craving_alcohol_deviation)))+geom_smooth(method='loess',na.rm = TRUE,span=0.75,se=FALSE)+coord_cartesian(ylim=c(-1,1))+
  theme_bw()+xlab('Minutes From BD Episode')+ylab('Craving Deviation')+ geom_vline(xintercept = 0, color = "red", size=0.5)
p2<-ggplot(hours_dataset_long_plot,aes(x=as.numeric(minutes_difference),y=as.numeric(impulsivity)))+geom_smooth(method='loess',na.rm = TRUE,span=0.75,se=FALSE)+coord_cartesian(ylim=c(1,3))+
  theme_bw()+xlab('Minutes From BD Episode')+ylab('Impulsivity Deviation')+ geom_vline(xintercept = 0, color = "red", size=0.5)
p3<-ggplot(hours_dataset_long_plot,aes(x=as.numeric(minutes_difference),y=as.numeric(negative_affect)))+geom_smooth(method='loess',na.rm = TRUE,span=0.75,se=FALSE)+coord_cartesian(ylim=c(1,4))+
  theme_bw()+xlab('Minutes From BD Episode')+ylab('Stress Deviation')+ geom_vline(xintercept = 0, color = "red", size=0.5)

figure <- ggarrange(p1, p2, p3,
                    ncol = 1, nrow = 3)
figure



## Data analysis
#Creating the polynomials
polynomials_binge <- ortho_poly_time(hours_dataset_long_plot,'minutes_difference',degree=3,include_zero =T)
hours_dataset_long_plot_poly <- cbind(hours_dataset_long_plot,polynomials_binge)

# Creating a before variable
hours_dataset_long_plot_poly$before <- 1
hours_dataset_long_plot_poly$before[hours_dataset_long_plot_poly$minutes_difference>=0]<- 0
hours_dataset_long_plot_poly$before <- as.factor(hours_dataset_long_plot_poly$before)

# No zero
#hours_dataset_long_plot_poly <- subset(hours_dataset_long_plot_poly,minutes_difference !=0)

### Models -------------
# Total
model_impulsivity <- lmer(as.numeric(impulsivity)~ minutes_difference_polynomial_1:before+minutes_difference_polynomial_2:before+minutes_difference_polynomial_3:before+
                            mean_impulsivity_participant+Age+BMI+
                            (1|Participant),data=hours_dataset_long_plot_poly)
summary(model_impulsivity)
