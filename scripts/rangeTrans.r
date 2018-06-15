#!/usr/bin/env Rscript
# Take a bedgraph file and performs ranged transformation (0-1)
# Oct 2017 Kenneth Condon
# https://stackoverflow.com/questions/5665599/range-standardization-0-to-1-in-r

##################################################################
# Setup ##########################################################
##################################################################
# Set working directory to source directory
setwd("~/NGS/UCSC_track_hubs/GreenfieldLabhubDirectory/mm10/data/encode/test")

# clear environment
rm(list=ls())

################################################################

# read data
df <- read.delim(file = "/home/kcondon/NGS/UCSC_track_hubs/GreenfieldLabhubDirectory/mm10/data/encode/test/ENCFF164ZFD_ctcf_kidney_8w.bedGraph", header = FALSE, dec = ".", fill = FALSE)
head(df)

# view distribution
plot(density(df$V4), main="peak scores")
boxplot(df$V4, col="darkgreen", main = "peak scores")

# log2 transform
df$V5 <-log2(df$V4+1)
head(df)

# view distribution
#plot(density(df$V5), main="log2(peak scores+1)")
#boxplot(df$V5, col="darkgreen", main = "log2(peak scores+1)")

# Calculate Upper Whisker (1.5*IQR)
log2.stats<-summary(df$V5)
log2.stats
log2.UQ<-as.double(log2.stats[5])
log2.LQ<-as.double(log2.stats[2])
log2.UW<- log2.UQ+(1.5*(log2.UQ-log2.LQ))

# count outliers (above upper whisker)
outliers.total<-length(df$V5[df$V5 > log2.UW])
outlier.percent <- 100*(outliers.total/length(df$V5))

# range transform  (0 = lowest value, 1 = upper whisker)
min.score <- min(df$V5)
df$V6 <- (df$V5-min.score)/(log2.UW-min.score)
head(df)

# view distribution
plot(density(df$V6), main="range transformed")
boxplot(df$V6, col="darkgreen", main = "range transformed")

# write output
df$V4 <- NULL
df$V5 <- NULL
df$V6 <- round(df$V6,digits=5)
write.table(df, file = paste("rangetransformed.bedGraph"), sep = "\t", dec = ".", row.names = FALSE, col.names = FALSE, quote = FALSE)

################################################################