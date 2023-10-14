imputed_cluster_analysis_part_1 <- function(data,n_imputations,variables,method,nrep,clustering_type,k_max,cvis,distance,
                                            centroid_type,multivar,multivariables,id,seed=23109){
  print('Impututing the datasets')
  imp <- mice(data, m=n_imputations, seed=seed,printFlag=FALSE)
  cluster_stats_dataframe <- data.frame()
  for (imputation in 1:n_imputations){
    print(paste('analyzing imputation',imputation,sep=' '))
    imputed_dataset <- complete(imp, imputation)
    # imputed_dataset[variables]<-scale(imputed_dataset[variables])
    if (multivar ==0){
      imputed_dataset_reduced <- select(imputed_dataset,variables)
    }
    if (multivar ==1){
      imputed_dataset_reduced <- list()
      for (id_entry in unlist(unique(imputed_dataset[id]))){
        imputed_dataset_reduced_id <- subset(imputed_dataset,imputed_dataset[id]==id_entry)
        imputed_dataset_reduced_id <- select(imputed_dataset_reduced_id,variables)
        imputed_dataset_reduced_id <- reshape(data=imputed_dataset_reduced_id,timevar=c("timepoints"),idvar=c(id),
                                              varying = variables,v.names = multivariables,direction="long", sep="_")
        imputed_dataset_reduced_id <- select(imputed_dataset_reduced_id,multivariables)
        imputed_dataset_reduced[[(length(imputed_dataset_reduced)+1)]]<-as.matrix(imputed_dataset_reduced_id)
      }
    }
    cluster_stats_imputation_dataframe <- data.frame()
    for (k in 2:k_max){
      if (clustering_type == 'hierarchical'){
        clustering <- tsclust(series = imputed_dataset_reduced,type = 'hierarchical',seed = seed,distance=distance,preproc=zscore,
                              centroid=centroid_type,control=hierarchical_control(method=method),k=k)
        cluster_metrics <- cvi(clustering)
        cluster_stats_imputation_dataframe[(k-1),1]<- k
          for (cvi_number in 1:length(cvis)){
            cvi_element <- cvis[cvi_number]
            cluster_stats_imputation_dataframe[(k-1),(1+cvi_number)]<- cluster_metrics[cvi_element]
          }
        colnames <- c('k',cvis)
        cluster_stats_imputation_dataframe <- setNames(cluster_stats_imputation_dataframe,colnames)
        }
      if (clustering_type == 'partitional'){
        clustering <- tsclust(series = imputed_dataset_reduced,type = 'partitional',seed = seed,distance=distance,preproc=zscore,
                              centroid=centroid_type,control=partitional_control(nrep=nrep),k=k)
        ## Finding best repetition
        cluster_metrics_best <- sapply(clustering[1], cvi, b = as.integer(clustering[[1]]@cluster))
        best_ess = cluster_metrics_best['Sil',]
        # best_ess = mean(clustering[[1]]@clusinfo[[2]]) 
        # best_rep = 1
        for (rep in 2:nrep){
          cluster_metrics_rep <- sapply(clustering[rep], cvi, b = as.integer(clustering[[rep]]@cluster))
          if (cluster_metrics_rep['Sil',] > best_ess){
            best_ess = cluster_metrics_rep['Sil',]
            best_rep = rep
          }
        }
        cluster_metrics <- sapply(clustering[best_rep], cvi, b = as.integer(clustering[[best_rep]]@cluster))
        cluster_stats_imputation_dataframe[(k-1),1]<- k
        for (cvi_number in 1:length(cvis)){
          cvi_element <- cvis[cvi_number]
          cluster_stats_imputation_dataframe[(k-1),(1+cvi_number)]<- cluster_metrics[cvi_element,]
        }
        colnames <- c('k',cvis)
        cluster_stats_imputation_dataframe <- setNames(cluster_stats_imputation_dataframe,colnames)
        }
      }
    cluster_stats_dataframe[imputation,1]<-imputation
    for (cvi_number in 1:length(cvis)){
      cvi_element <- cvis[cvi_number]
      cluster_stats_dataframe[imputation,(2*cvi_number)] <- max(cluster_stats_imputation_dataframe['k'][cluster_stats_imputation_dataframe[cvis[cvi_number]]==max(cluster_stats_imputation_dataframe[,(cvi_number+1)])])
      cluster_stats_dataframe[imputation,(2*cvi_number+1)] <- max(cluster_stats_imputation_dataframe[,(cvi_number+1)])
    }
  }
  cluster_stats_dataframe_colnames <- c('Imputation')
  for (cvi_number in 1:length(cvis)){
    cluster_stats_dataframe_colnames[2*cvi_number] <- paste('k_best_',cvis[cvi_number],sep='')
    cluster_stats_dataframe_colnames[2*cvi_number+1] <- paste(cvis[cvi_number],'_max',sep='')
  }
  cluster_stats_dataframe <- setNames(cluster_stats_dataframe,cluster_stats_dataframe_colnames)
  return(cluster_stats_dataframe)
}
