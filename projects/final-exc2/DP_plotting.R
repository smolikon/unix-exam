library(tidyverse)
setwd("~/projects/final-exc2")
read_tsv(file = 'data/col-final.tsv', show_col_types = FALSE) -> df


##DP distribution in genome
hist(log(x=df$DP),
     xlab = "log10 DP",
     main= "Distribution of read depth in the whole genome")


##DP by chromosomes_global
order <- c("chr1", "chr2", "chr3", "chr4", "chr5", "chr6", "chr7", "chr8",
           "chr9", "chr10", "chr11", "chr12", "chr13", "chr14", "chr15",
           "chr16", "chr17", "chr18", "chr19", "chr20", "chr21", "chr22",
           "chr23", "chr24", "chr25", "chr26", "chr27", "chr28", "chrM", "chrZ")

ggplot(df, aes(x=factor(CHROM, levels=order), y=DP)) +
  geom_violin(trim = TRUE) +
  ggtitle("Distribution of read depth by chromosome") +
  ylab("Read depth (DP)") +
  xlab(NULL) +
  theme(legend.position="none")


##DP mapped on specific chromosome
#example chr1
chr <- df[df$CHROM=="chr1", ] #edit this line for chr[1-28] or chrM or chrZ

ggplot(chr, aes(x=POS, y=DP, color=DP)) + 
  geom_point(size=0.5, alpha=0.75) + 
  ggtitle("Read depth over chromosome 1") + #edit also this title
  ylab("Read depth (DP)") +
  xlab("Position on chromosome")


