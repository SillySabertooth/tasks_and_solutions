#!/bin/bash

java -Xmx4g -jar snpEff.jar BDGP6.86 ./FASTQ/Ber.vcf > ./FASTQ/Ber.ann.vcf

java -jar SnpSift.jar filter  "(( DP > 10 ) & (QUAL >= 30))" ./FASTQ/Ber.ann.vcf > ./FASTQ/Ber.qual.vcf


java -jar SnpSift.jar filter  "ANN[*].EFFECT has 'nonssense_variant'" ./FASTQ/Ber.ann.vcf > ./FASTQ/Ber.ann.nonssense_4.vcf


java -jar SnpSift.jar filter  "((ANN[*].EFFECT has 'missense_variant') | (ANN[*].EFFECT has 'nonsense_variant'))" ./FASTQ/Ber.ann.vcf > ./FASTQ/Ber.ann.filter_nonsense_third.vcf


java -jar SnpSift.jar filter  "ANN[*].EFFECT has 'nonsense_variant'" ./FASTQ/Ber.ann.vcf > ./FASTQ/Ber.ann.filter_missense_first.vcf



