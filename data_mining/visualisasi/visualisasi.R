# menginstall dplyr untuk manipulasi DataFrame
# dan ggplot2 untuk visualisasi data
library(dplyr)
library(ggplot2)

# membaca dataset
fao_data <- read.csv("D:/Tugas/daming_s2/Crops_AllData_Normalized.csv")

# menampilkan 5 baris teratas
head(fao_data, 5)

# pilih negara Indonesia
data_indonesia <- fao_data %>% filter(Area=="Indonesia")

# menampilkan 5 baris teratas
head(data_indonesia, 5)

# statistik deskriptif
summary(data_indonesia)

# produksi Indonesia
data_indonesia %>% select(Item) %>% unique

# fungsi untuk mendapatkan top produksi Indonesia
top_crops <- function(top_n=5) {
  return (data_indonesia %>% 
    filter(Element=="Production") %>% 
    group_by(Item) %>% 
    summarize(aggval=mean(Value)) %>% 
    slice_max(order_by=aggval, n=top_n) %>% 
    select(Item) %>% 
    pull)
}

# boxplot 1
data_box1 <- data_indonesia %>% select(Element, Value)

ggplot(data_box1, aes(x=Element, y=Value)) + 
  geom_boxplot()

# boxplot 2
data_box2 <- data_indonesia %>% 
  filter(Item %in% top_crops(5)) %>% 
  select(Element, Item, Value)

ggplot(data_box2, aes(x=Item, y=Value, fill=Element)) + 
  geom_boxplot() + 
  facet_wrap(~Element, scales = "free") + 
  theme(axis.text.x=element_text(angle=45, vjust=0.5, hjust=0.5))

# histogram 1
data_hist1 <- data_indonesia %>% 
  filter(Item=="Oilcrops") %>% 
  select(Element, Item, Value)

ggplot(data_hist1, aes(x=Value)) + 
  geom_histogram(alpha=0.6) + 
  facet_wrap(~Element, scales="free") + 
  theme(axis.text.x=element_text(angle=45, vjust=0.5, hjust=0.5))

# histogram 2
data_hist2 <- data_indonesia %>% 
  filter(Element=="Production", Item %in% top_crops(6)) %>% 
  select(Element, Item, Value)

ggplot(data_hist2, aes(x=Value)) + 
  geom_histogram(alpha=0.6) + 
  facet_wrap(~Item, scales = "free") + 
  theme(axis.text.x=element_text(angle=45, vjust=0.5, hjust=0.5))

