# unix-exam
# UNIX course: final exercise

## Task 2 - Distribution of read depth (DP) over the whole genome and by chromosome
This repository represents my final exercise for the UNIX course 2021. I have chosen the task nr 2.

### Data processing
Note: Source data file (~/projects/luscinia_vars.vcf.gz) was processed locally.
```{bash}
mkdir -p ~/projects/final-exc2/data
#prepare data directory
cd ~/projects/final-exc2                                              
#go to working directory

< ~/projects/luscinia_vars.vcf.gz zcat |                              
#load source data and unzipping them
	grep -v '^#' |                                                      
	#select only real data (not headers or comments)
  grep -e '^chr[0-9]\s' -e '^chr[0-9][0-9]\s' -e '^chr[A-Z]\s' |      
  #select only data valid for standard karyotype nomenclature (here, I might be wrong in excluding some)
	sort -k1,1 -k2,2n                                                   
	#sort the data based on chromosome and position of the read on it
  > data/no-head.vcf                                                  
  #create clear working data file

INPUT=data/no-head.vcf                                                
#define input file
<$INPUT cut -f 1-2 > data/col-select.tsv                              
#extract chromosome and position column
<$INPUT egrep -o 'DP=[^;]*' | sed 's/DP=//' > data/col-dp.tsv         
#extract read depth values

wc -l data/*.tsv                                                      
#check number of lines before merging
paste data/col-select.tsv data/col-dp.tsv > data/col-all.tsv          
#merge data into R-ready file
echo -e "CHROM\tPOS\tDP" | cat - data/col-all.tsv > data/col-final.tsv                         
#add headers and you are ready for plotting
```
### Plotting in R
```{r}
library(tidyverse)
#loading plotting library
setwd("~/projects/final-exc2")
#setting working directory
read_tsv(file = 'data/col-final.tsv', show_col_types = FALSE) -> df
#loading data file
```
#### Distribution of read depth in the whole genome
I decided to plot a histogram with log-scale to enhance visibility of the most abundant values.
```{r}
hist(log(x=df$DP),
     xlab = "log10 DP",
     main= "Distribution of read depth in the whole genome")
```
![01_DP_genome](https://user-images.githubusercontent.com/95181389/148691232-2a0fb6d9-2b4e-4a8e-974e-759e68deef18.png)



#### Distribution of read depth by chromosome
I wanted to show comparision in read depth distribution for each chromosome in karyotype.
```{r}
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
```
![02_DP_chromosomes](https://user-images.githubusercontent.com/95181389/148691211-05144140-203c-47bd-ae75-066b5c565415.png)


#### Distribution of read depth over chromosome
I wanted to make use of the position information and show loci, where reads were not present.
```{r}
chr <- df[df$CHROM=="chr1", ] #edit this line for chr[1-28] or chrM or chrZ
#defining data subset for a specific chromosome
ggplot(chr, aes(x=POS, y=DP, color=DP)) + 
  geom_point(size=0.5, alpha=0.75) + 
  ggtitle("Read depth over chromosome 1") + #edit also this title
  ylab("Read depth (DP)") +
  xlab("Position on chromosome")
```
![03_DP_chr1_example](https://user-images.githubusercontent.com/95181389/148691201-46bb3572-52f0-4ae8-8c8e-c94d7ea8e1e1.png)
