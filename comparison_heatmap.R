#library("gplots")
.libPaths('/home/cstorer/R/x86_64-pc-linux-gnu-library/4.2')


library("RColorBrewer")
library("pheatmap")

args = commandArgs(trailingOnly=TRUE)

dat <- read.table(args[1], header=T, sep=",")

dat$X <- NULL  #get rid of X column

#add 1 to col 1 #remove this-----------------
#dat[,1] <- dat[,1] +1
#--------------------------------------------

dat <- dat -1
#c_names <- c("Root_1",  "Root_2", "Root_3", "Root_4", "Root_5", "Root_6", 
#"Root_7", "Root_8", "Root_9", "Root_10", "Root_11", "Root_12", "Root_13", "Root_14", 
#"Root_15", "Root_16", "Root_17", "Root_18", "Root_19", "Root_20")

#r_names <- c("Compare_1",  "Compare_2", "Compare_3", "Compare_4", "Compare_5", "Compare_6", 
#"Compare_7", "Compare_8", "Compare_9", "Compare_10", "Compare_11", "Compare_12", "Compare_13", "Compare_14", 
#"Compare_15", "Compare_16", "Compare_17", "Compare_18", "Compare_19", "Compare_20")

c_names <- readLines("comp.t_annot")
r_names <- readLines("root.t_annot")

#colnames(dat) <- c_names
#rownames(dat) <- r_names
rownames(dat) <- c_names
colnames(dat) <- r_names

col <- colorRampPalette(brewer.pal(10, "RdYlBu"))(256)

dat <- as.matrix(dat)
pdf("comparisons.pdf", width=10, height=7)
pheatmap(dat)
dev.off()
