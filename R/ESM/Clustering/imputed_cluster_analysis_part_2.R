imputed_cluster_analysis_part_2 <- function(data,n_imputations,variables,method,nrep,clustering_type,
                                            k,distance,centroid_type,multivar,multivariables,id,seed=23109){
  print('Impututing the datasets')
  imp <- mice(data, m=n_imputations, seed=seed,printFlag=FALSE)
  imputation_datasets_all <-data.frame()
  data_clusters_all <- data.frame()
  for (imputation in 1:n_imputations){
    print(paste('analyzing imputation',imputation,sep=' '))
    imputed_dataset <- complete(imp, imputation)
    imputed_dataset_original <- imputed_dataset
    imputed_dataset[variables]<-zscore(imputed_dataset[variables])
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
    if (clustering_type == 'hierarchical'){
      clustering <- tsclust(series = imputed_dataset_reduced,type = 'hierarchical',seed = seed,distance=distance,preproc=zscore,
                            centroid=centroid_type,control=hierarchical_control(method=method),k=k)
      data_clusters <- cutree(clustering, k = k)
    }
    if (clustering_type == 'partitional'){
      clustering <- tsclust(series = imputed_dataset_reduced,type = 'partitional',seed = seed,distance=distance,
                            centroid=centroid_type,control=partitional_control(nrep=nrep),k=k)
      ## Finding best repetition
      best_ess = mean(clustering[[1]]@clusinfo[[2]]) 
      best_rep = 1
      for (rep in 2:nrep){
        if (mean(clustering[[rep]]@clusinfo[[2]]) < best_ess){
          best_ess = mean(clustering[[rep]]@clusinfo[[2]])
          best_rep = rep
        }
      }
      data_clusters <- clustering[[best_rep]]@cluster
    }
    imputed_dataset <- cbind(imputed_dataset_original,data_clusters)
    rows_imputation_datasets_all <- nrow(imputation_datasets_all)
    imputation_datasets_all[(rows_imputation_datasets_all+1):(rows_imputation_datasets_all+nrow(imputed_dataset)),1]<-imputation
    imputation_datasets_all[(rows_imputation_datasets_all+1):(rows_imputation_datasets_all+nrow(imputed_dataset)),2:(ncol(imputed_dataset)+1)] <- imputed_dataset
    data_clusters_all[imputation,1]<-imputation
    data_clusters_all[imputation,2:(length(data_clusters)+1)]<- data_clusters
  }
  output  <- list(data_clusters_all,imputation_datasets_all)
  return(output)
}
