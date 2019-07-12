#!/bin/bash

Path_to_pr=/home/silly/progs
Ref=/media/silly/Databases/Ref/GRCh37_by_hand.fna
for i in {1..255}
do
if [[ -f ${i}.m.sort.bam ]]; then


$Path_to_pr/samtools-1.5/samtools mpileup -f /$Ref ${i}.m.sort.bam | java -jar $Path_to_pr/VarScan.v2.3.9.jar mpileup2snp --output-vcf 1 > ${i}_lots_var.vcf
grep -w "^#*\|^#CHROM\|^chrMT" ${i}_lots_var.vcf > ${i}.vcf


$Path_to_pr/samtools-1.5/samtools mpileup -f /$Ref ${i}.m.sort.bam | java -jar $Path_to_pr/VarScan.v2.3.9.jar mpileup2indel --output-vcf 1 > ${i}_indels.vcf



fi
done
      

