#------------------------------------------------------------------------------#
# Histogram of Binding Affinities from Autodock Vina
#------------------------------------------------------------------------------#


library(ggplot2)




baffinity <- read.table("Downloads/vina_log.txt")

colnames(baffinity) <- c("compound", "affinity")

ggplot(as.data.frame(baffinity), aes(x=affinity)) + geom_histogram(binwidth = 0.1)



top10 <- baffinity[head(order(baffinity$affinity), 10), ]


write.table(top10[,1], "~/Downloads/top10.txt", quote = FALSE, row.names = FALSE, col.names = FALSE)
