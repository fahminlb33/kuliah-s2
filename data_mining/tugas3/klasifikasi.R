library(dplyr)
library(ggplot2)
library(C50)
library(caret)

# membaca dataset
df <- read.csv("dataset_aqi.csv")

# memisahkan variabel input dan target
X <- df %>% select(CO.AQI.Value, Ozone.AQI.Value, NO2.AQI.Value, PM2.5.AQI.Value)
y <- df %>% select(AQI.Category) %>% pull %>% as.factor

in_train <- sample(1:nrow(X), size=nrow(X) * 0.7)
X_train <- X[in_train,]
y_train <- y[in_train]
X_test <- X[-in_train,]
y_test <- y[-in_train]

# membuat classifier
clf <- C5.0(X_train, y_train, rules=FALSE)

# menampilkan tree
plot(clf)

# menampilkan summary
summary(clf)

# menampilkan informasi penggunaan atribut
C5imp(clf, metric='usage')

# menguji dengan data testing
y_pred <- predict(clf, X_test, type="class")
confusionMatrix(data=y_pred, reference=y_test)

# melakukan prediksi data diluar sampel
X_pred <- data.frame(CO.AQI.Value=10, Ozone.AQI.Value=22, NO2.AQI.Value=12, PM2.5.AQI.Value=111)
predict(clf, X_pred, type="prob")    # output probabilitas
predict(clf, X_pred, type="class")   # output kelas

