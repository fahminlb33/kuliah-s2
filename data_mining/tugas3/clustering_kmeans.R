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
ggpairs(df, columns=c(5,7,9,11), mapping=aes(color=AQI.Category))

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

# metode elbow
df_sse <- data.frame(k=1:10, sse=sapply(1:10, function(k){kmeans(X, centers=k)$tot.withinss}))

ggplot(df_sse, aes(x=k, y=sse)) +
  geom_line() +
  geom_point() +
  geom_text(data=df_sse, aes(x=k, y=sse, label=k), vjust=1.5)

# melakukan clustering dengan k-means dengan nilai k=4
clus_kmeans <- kmeans(X, centers=4)
clus_kmeans_clusters <- as.factor(clus_kmeans$cluster)

# menampilkan rata-rata atribut berdasarkan cluster
summarize_cluster(df, clus_kmeans_clusters)

# menampilkan scatter plot cluster untuk 2 atribut
ggplot(df, aes(x=Ozone.AQI.Value, y=PM2.5.AQI.Value)) + 
  geom_point(aes(colour=clus_kmeans_clusters))

# melakukan biplot analysis (PCA 2 komponen) berdasarkan kategori asli
clusplot(X, df$AQI.Category, shade=TRUE, color=TRUE, main=paste("AQI"))

# melakukan biplot analysis (PCA 2 komponen) berdasarkan cluster
clusplot(X, clus_kmeans_clusters, shade=TRUE, color=TRUE, main=paste("AQI"))

# perbandingan mean kategori asli dan hasil cluster
summarize_cluster(df, df$AQI.Category)
