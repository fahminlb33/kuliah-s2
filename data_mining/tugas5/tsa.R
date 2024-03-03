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

head(df_hourly)

describe(df_hourly[, -1])

min(df_hourly$ts)
max(df_hourly$ts)

total_suara <- sum(df_hourly$paslon1) + sum(df_hourly$paslon2) + sum(df_hourly$paslon3)
df_percentage <- df_hourly %>%
    summarise(
      percent_paslon1 = sum(paslon1) / total_suara * 100,
      percent_paslon2 = sum(paslon2) / total_suara * 100,
      percent_paslon3 = sum(paslon3) / total_suara * 100
    ) %>% 
  t() %>% 
  as.data.frame() %>%
  setNames(c('percentage')) %>%
  mutate(
    paslon = c('Paslon 1', 'Paslon 2', 'Paslon 3'),
  )

ggplot(df_percentage, aes(x="", y=percentage, fill=paslon)) + 
  geom_col() + 
  geom_label(aes(label = percentage), position=position_stack(vjust=0.5)) +
  coord_polar("y", start=0) +
  theme_void()
  

# --- viusualisasi time series

ds_hourly <- xts(df_hourly[, -1], order.by=df_hourly$ts)

dygraph(ds_hourly[, 1:3])
dygraph(ds_hourly[, 4:6])


# --- dekomposisi time series dan autocorrelations

paslon1.ts_hourly <- ts(ds_hourly$paslon1, frequency=24)

paslon1_decomp <- decompose(paslon1.ts_hourly)
plot(paslon1_decomp)

paslon2.ts_hourly <- ts(ds_hourly$paslon2, frequency=24)

paslon2_decomp <- decompose(paslon2.ts_hourly)
plot(paslon2_decomp)

# autocorrelation function

acf(paslon1.ts_hourly)

acf(paslon2.ts_hourly)
