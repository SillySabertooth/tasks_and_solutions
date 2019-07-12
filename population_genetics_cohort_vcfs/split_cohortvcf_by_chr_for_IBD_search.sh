#!/bin/bash

#IBD сегменты ищутся по контигам - нужно разбить когортным vcf по хросомам
mkdir all_chr
cd all_chr
for i in {1..22}
do
grep -w "^#*\|^#CHROM\|^chr${i}" ../all_by_excel_from_72_samples.vcf > chr${i}.vcf
done

for i in X Y M Un_gl000220
do
grep -w "^#*\|^#CHROM\|^chr${i}" ../all_by_excel_from_72_samples.vcf > chr${i}.vcf
done


