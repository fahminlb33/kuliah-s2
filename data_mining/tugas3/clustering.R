library(tidyverse)
library(dplyr)
library(ggplot2)
library(cluster)
library(fpc)
library(patchwork)
library(GGally)

#
# Data loading & wrangling
#

# membaca dataset
df <- read.csv("dataset_aqi.csv")

# menampilkan pair plot (scatter) antar variabel
ggpairs(df, columns=c(5,7,9,11), aes(color=AQI.Category))

# untuk menghitung mean atribut input per cluster
summarize_cluster <- function(X, clusters) {
  df_sum <- X
  df_sum$Cluster <- clusters
  
  return (df_sum %>% 
    group_by(Cluster) %>% 
    summarize(
      co_mean=mean(CO.AQI.Value),
      ozone_mean=mean(Ozone.AQI.Value),
      no2_mean=mean(NO2.AQI.Value),
      pm25_mean=mean(PM2.5.AQI.Value)
    )
  )
}

# untuk melakukan min-max scaling
normalize <- function(x, na.rm = TRUE) {
  return((x- min(x)) /(max(x)-min(x)))
}

# memilih atribut input untuk di-clustering
X <- df %>% 
  select(CO.AQI.Value, Ozone.AQI.Value, NO2.AQI.Value, PM2.5.AQI.Value) %>%
  normalize

#
# k-means clustering
#

# melakukan clustering dengan k-means dengan nilai k=3
clus_kmeans <- kmeans(X, centers=3)
clus_kmeans_clusters <- as.factor(clus_kmeans$cluster)

# menampilkan rata-rata atribut berdasarkan cluster
summarize_cluster(df, clus_kmeans_clusters)

# menampilkan scatter plot cluster untuk 2 atribut
ggplot(df, aes(x=Ozone.AQI.Value, y=PM2.5.AQI.Value)) + 
  geom_point(aes(colour=clus_kmeans_clusters))

# menampilkan scatter plot cluster untuk 2 atribut beserta centroid nya
ggplot(df, aes(x=Ozone.AQI.Value, y=PM2.5.AQI.Value)) + 
  geom_point(aes(colour=clus_kmeans_clusters)) + 
  geom_point(data=as.data.frame(clus_kmeans$centers), size=5)

# melakukan biplot analysis (PCA 2 komponen) berdasarkan cluster
clusplot(X, clus_kmeans_clusters, shade=TRUE, color=TRUE, main=paste("AQI"))

#
# Hierarchical clustering
#

# melakukan clustering menggunakan hierarchical clustering dengan distance=average
cls_hier <- hclust(dist(X), method="ave")
cls_hier_clusters <- as.factor(cutree(cls_hier, k=3))

# menampilkan dendogram
plot(cls_hier, hang=-1)
rect.hclust(cls_hier, k=3)

# menampilkan rata-rata atribut berdasarkan cluster
summarize_cluster(X, cls_hier_clusters)

# menampilkan scatter plot cluster untuk 2 atribut
ggplot(df, aes(x=Ozone.AQI.Value, y=PM2.5.AQI.Value)) + 
  geom_point(aes(colour=cls_hier_clusters))

# melakukan biplot analysis (PCA 2 komponen) berdasarkan cluster
clusplot(X, cls_hier_clusters, shade=TRUE, color=TRUE, main=paste("AQI"))

#
# Density-based Clustering (DBSCAN)
#

# melakukan clustering menggunakan DBSCAN
clus_dbs <- dbscan(X, eps=0.02, MinPts=5)
clus_dbs_clusters <- as.factor(clus_dbs$cluster)

# menampilkan rata-rata atribut berdasarkan cluster
summarize_cluster(df, clus_dbs_clusters)

# menampilkan scatter plot cluster untuk 2 atribut
ggplot(df, aes(x=Ozone.AQI.Value, y=PM2.5.AQI.Value)) + 
  geom_point(aes(colour=clus_dbs_clusters))

# melakukan biplot analysis (PCA 2 komponen) berdasarkan cluster
clusplot(X, clus_dbs_clusters, shade=TRUE, color=TRUE, main=paste("AQI"))

#
# Perbandingan hasil cluster
#

# perbandingan berdasarkan plot scatter
plot_kmeans <- ggplot(df, aes(x=Ozone.AQI.Value, y=PM2.5.AQI.Value)) + 
  geom_point(aes(colour=clus_kmeans_clusters), show.legend=FALSE) +
  ggtitle("K-means")
plot_hier <- ggplot(df, aes(x=Ozone.AQI.Value, y=PM2.5.AQI.Value)) + 
  geom_point(aes(colour=cls_hier_clusters), show.legend=FALSE) +
  ggtitle("Hierarchical Clustering (Avg link)")
plot_dbscan <- ggplot(df, aes(x=Ozone.AQI.Value, y=PM2.5.AQI.Value)) + 
  geom_point(aes(colour=clus_dbs_clusters), show.legend=FALSE) +
  ggtitle("DBSCAN")

plot_kmeans + plot_hier + plot_dbscan

# perbandingan berdasarkan mean