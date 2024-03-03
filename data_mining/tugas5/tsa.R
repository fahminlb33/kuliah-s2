library(xts)
library(TTR)
library(tsbox)
library(tidyverse)
library(dygraphs)
library(ggplot2)
library(psych)

# --- memuat data

# memuat data suara per jam
df_hourly <- read.csv("hasil_tps_hourly.csv")
df_hourly$ts <- as.POSIXct(df_hourly$ts, format="%Y-%m-%d %H:%M:%S")
df_hourly <- df_hourly %>%
  arrange(ts) %>%
  mutate(
    paslon1_cumsum = cumsum(paslon1),
    paslon2_cumsum = cumsum(paslon2),
    paslon3_cumsum = cumsum(paslon3)
  )

# menampilkan sampel data
head(df_hourly)

# menghitung statistik deskriptif
describe(df_hourly[, -1])

# menampilkan nilai minimum dan maksimum dari atribut waktu
min(df_hourly$ts)
max(df_hourly$ts)

# menghitung total suara dari ketiga paslon
total_suara <- sum(df_hourly$paslon1) + sum(df_hourly$paslon2) + sum(df_hourly$paslon3)

# menghitung presentase perolehan suara ketiga paslon
df_percentage <- df_hourly %>%
    summarise(
      percent_paslon1 = round(sum(paslon1) / total_suara * 100, 2),
      percent_paslon2 = round(sum(paslon2) / total_suara * 100, 2),
      percent_paslon3 = round(sum(paslon3) / total_suara * 100, 2)
    ) %>% 
  t() %>% 
  as.data.frame() %>%
  setNames(c('percentage')) %>%
  mutate(
    paslon = c('Paslon 1', 'Paslon 2', 'Paslon 3'),
  )

# menampilkan diagram lingkaran perolehan suara paslon
ggplot(df_percentage, aes(x="", y=percentage, fill=paslon)) + 
  geom_col() + 
  geom_label(aes(label = percentage), position=position_stack(vjust=0.5)) +
  coord_polar("y", start=0) +
  theme_void()

# menjumlahkan perolehan suara paslon pada bulan Februari 1-18
df_hourly %>% filter(month(ts) == 2, day(ts) <= 18) %>% select(paslon2) %>% sum

# menjumlahkan total suara masuk pada bulan Februari 1-18
df_hourly %>% filter(month(ts) == 2, day(ts) <= 18) %>% select(paslon1, paslon2, paslon3) %>% sum

# menampilkan baris dengan nilai perolehan suara sama dengan 0
df_hourly %>% filter(paslon1 == 0)

# menampilkan 2 perolehan suara tertinggi
df_hourly %>% arrange(desc(paslon2)) %>% head

# diagram pencar dan
ggplot() + 
  geom_point(data=df_hourly, aes(x=ts, y=paslon1_cumsum, color='Paslon 1')) +
  geom_smooth(data=df_hourly, aes(x=ts, y=paslon1_cumsum, color='Paslon 1'), method="lm", se=FALSE, linetype="dashed") +
  geom_point(data=df_hourly, aes(x=ts, y=paslon2_cumsum, color='Paslon 2')) +
  geom_smooth(data=df_hourly, aes(x=ts, y=paslon2_cumsum, color='Paslon 2'), method="lm", se=FALSE, linetype="dashed") +
  geom_point(data=df_hourly, aes(x=ts, y=paslon3_cumsum, color='Paslon 3')) + 
  geom_smooth(data=df_hourly, aes(x=ts, y=paslon3_cumsum, color='Paslon 3'), method="lm", se=FALSE, linetype="dashed") +
  xlab('Waktu') + 
  ylab('Perolehan Suara')


# --- viusualisasi time series

# membuat time series (xts)
ds_hourly <- xts(df_hourly[, -1], order.by=df_hourly$ts)

# menampilkan grafik perolehan suara per jam
dygraph(ds_hourly[, 1:3])

# menampilkan grafik perolehan suara kumulatif per jam
dygraph(ds_hourly[, 4:6])


# --- dekomposisi time series dan autocorrelations

# membuat time series (ts)
paslon1.ts_hourly <- ts(ds_hourly$paslon1, frequency=24)
paslon2.ts_hourly <- ts(ds_hourly$paslon2, frequency=24)

# menampilkan dekomposisi time series paslon 1
paslon1_decomp <- decompose(paslon1.ts_hourly)
plot(paslon1_decomp)

# menampilkan dekomposisi time series paslon 2
paslon2_decomp <- decompose(paslon2.ts_hourly)
plot(paslon2_decomp)

# autocorrelation function

acf(paslon1.ts_hourly)

acf(paslon2.ts_hourly)

