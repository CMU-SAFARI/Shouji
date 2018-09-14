12 read sets are generated using mrFAST by mapping the following datasets to the human reference genome (GRCh37):
1. https://www.ebi.ac.uk/ena/data/view/ERR240727
2. https://www.ebi.ac.uk/ena/data/view/SRR826460
3. https://www.ebi.ac.uk/ena/data/view/SRR826471

We use the following command to capture the read-reference pairs:
```
./mrfastPrintPairs --search ../human_g1k_v37.fasta --seq ../ERR240727_1.filt.fastq -e 2 | awk -F'\t' '{ if (substr($2,1,1) ~ /^[A,C,G,T]/ ) print $0}' |head -n 30000000 > ../../ERR240727_1_E1_50million_new2.txt
```

Above, we only provide sample of the 4 read-reference sets generated from Illumina 100 bp reads. 
