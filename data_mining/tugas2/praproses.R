# install packages
library(tidyverse)
library(ggplot2)
library(dplyr)
library(tidyr)

# membaca dataset
# sumber: https://www.kaggle.com/datasets/adityaramachandran27/world-air-quality-index-by-city-and-coordinates
df <- read.csv("D:\\Tugas\\daming_s2\\tugas2\\aqi.csv")

# melihat sampel data
head(df)

# Tugas 1 - Penanganan missing values

# replace string kosong menjadi NA
df[df == ""] <- NA

# menghitung missing values
colSums(is.na(df))

# karena hanya terdapat sedikit data yang mengandung null, maka row akan dihapus
df <- df %>% filter(!is.na(Country))

# menampilkan hasil
colSums(is.na(df))

# Tugas 2 - Feature Scaling

# melakukan scaling untuk kolom AQI.Value dan menambahkan kolom AQI scaled ke df
df <- df %>% mutate(aqi_scaled=scale(df$AQI.Value))

# menampilkan hasil
head(df)

# Tugas 3 - Normalization

# membuat fungsi untuk melakukan min-max scaling
minMax <- function(x, na.rm = TRUE) {
  return ((x- min(x)) /(max(x)-min(x)))
}

# melakukan normalisasi untuk kolom CO.AQI.Value, Ozone.AQI.Value, NO2.AQI.Value, dan PM2.5.AQI.Value
df <- df %>% 
  mutate(co_norm=minMax(CO.AQI.Value)) %>%
  mutate(ozone_norm=minMax(Ozone.AQI.Value)) %>%
  mutate(no2_norm=minMax(NO2.AQI.Value)) %>%
  mutate(pm25_norm=minMax(PM2.5.AQI.Value))

# menampilkan hasil
head(df)

# Tugas 4 - Feature Encoding (One hot atau Ordinal)

# mencari nilai unik untuk kolom Category
df$AQI.Category %>% unique

# membuat pemetaan taraf kategori
# sumber: https://www.airnow.gov/aqi/aqi-basics/
category_levels = c(
  "Good" = 1,
  "Moderate" = 2,
  "Unhealthy for Sensitive Groups" = 3,
  "Unhealthy" = 4,
  "Very Unhealthy" = 5,
  "Hazardous" = 6
)

# melakukan ordinal encoding
df <- df %>% 
  mutate(co_cat=category_levels[CO.AQI.Category]) %>%
  mutate(ozone_cat=category_levels[Ozone.AQI.Category]) %>%
  mutate(no2_cat=category_levels[NO2.AQI.Category]) %>%
  mutate(pm25_cat=category_levels[PM2.5.AQI.Category])

# menampilkan hasil
head(df)

# Tugas 5 - Handling Outlier (metode IQR)

# menentukan threshold IQR
iqr_threshold = 1.5

# menantukan kolom yang akan diproses
outlier_columns = c("co_norm", "ozone_norm", "no2_norm", "pm25_norm")

# menampilkan summary
summary(df)

# menampilkan boxplot
ggplot(df %>% select(all_of(outlier_columns)) %>% pivot_longer(cols = outlier_columns), aes(x=name, y=value)) + geom_boxplot()

# melakukan outlier removal menggunakan metode IQR
for (column in outlier_columns) {
  # menghitung IQR
  col_iqr <- IQR(df[[column]])
  
  # menghitung Q1 dan Q3
  col_quartiles <- quantile(df[[column]], probs=c(.25, .75))
  
  # menentukan batas bawah/atas
  qlower <- col_quartiles[1] - iqr_threshold * col_iqr
  qupper <- col_quartiles[2] + iqr_threshold * col_iqr
  
  # memfilter data berdasarkan batas bawah/atas
  df <- df %>% filter(.[[column]] >= qlower & .[[column]] <= qupper)
}

# menampilkan hasil
summary(df)

# menampilkan boxplot
ggplot(df %>% select(all_of(outlier_columns)) %>% pivot_longer(cols = outlier_columns), aes(x=name, y=value)) + geom_boxplot()
