#!/bin/bash

mkdir -p ~/projects/final-exc2/data
cd ~/projects/final-exc2
< ~/projects//luscinia_vars.vcf.gz zcat | grep -v '^#' | grep -e '^chr[0-9]\s' -e '^chr[0-9][0-9]\s' -e '^chr[A-Z]\s' | sort -k1,1 -k2,2n > data/no-head.vcf

INPUT=data/no-head.vcf
<$INPUT cut -f 1-2 > data/col-select.tsv
<$INPUT egrep -o 'DP=[^;]*' | sed 's/DP=//' > data/col-dp.tsv

wc -l data/*.tsv
paste data/col-select.tsv data/col-dp.tsv > data/col-all.tsv
echo -e "CHROM\tPOS\tDP" | cat - data/col-all.tsv > data/col-final.tsv



 
