library(arules)
library(arulesViz)
library(igraph)
library(RColorBrewer)

# membaca dataset sebagai transactions
tr <- read.transactions("retail.txt")

# menampilkan keterangan dataset
summary(tr)

# menampilkan frekuensi item paling banyak dalam dataset
itemFrequencyPlot(tr, topN=10, type="absolute", col=brewer.pal(8,'Pastel2'))

# melakukan ekstraksi rules menggunakan Apriori
rules <- apriori(tr, parameter=list(supp=0.001, maxlen=50))

# menampilkan plot confidence-support
plot(rules)

# menampilkan plot confidence-support
plot(rules, method="two-key plot")

# menampilkan plot support-lift untuk kelompok rule
plot(rules, method="grouped")

# explore rules menggunakan shine (mode interaktif)
ruleExplorer(rules)

# memisahkan rule dengan target 38
rules.sub_rsh_38 <- subset(rules, subset=rhs %in% "38")

# menampilkan sampel rule
inspect(head(rules.sub_rsh_38, n=10, by="lift"))

# menampilkan plot rule sebagai graf
plot(head(rules.sub_rsh_38, n=10, by="lift"), method = "paracoord")

# quality per itemset (confidence, support, lift)
rules.quality <- quality(rules)
rules.quality

# top 10 rules berdasarkan confidence
top10subRules <- head(rules, n=10, by = "confidence")
plot(top10subRules, method="graph", engine="htmlwidget")

