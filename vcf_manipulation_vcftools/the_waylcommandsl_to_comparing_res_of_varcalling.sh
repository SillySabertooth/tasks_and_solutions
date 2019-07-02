#!/bin/bash

#for i in {1..100}
for i in 21
do
if [[ -f ${i}_last.vcf ]]; then

#просто с форс работает и без перевода формата всф; и чтобы не менять названия файлов, прост так создаю еще один файл
#####можно циклить, было бы желание; и потом таблицы делать и визуализировать как-то
#cat ${i}_varscan.vcf | ~/progs/vcftools/src/perl/vcf-convert -v 4.2 > ${i}_varscan2.vcf
cat ${i}_varscan.vcf > ${i}_varscan2.vcf

bgzip ${i}_last.vcf
bgzip ${i}_varscan2.vcf

tabix -p vcf ${i}_last.vcf.gz
tabix -p vcf ${i}_varscan2.vcf.gz
gunzip -k ${i}_varscan2.vcf.gz
gunzip -k ${i}_last.vcf.gz

~/progs/vcftools/src/perl/vcf-isec -c -f ${i}_last.vcf.gz ${i}_varscan2.vcf.gz > ${i}_free_var.vcf 
~/progs/vcftools/src/perl/vcf-isec -c -f ${i}_varscan2.vcf.gz ${i}_last.vcf.gz > ${i}_var_free.vcf 

fi
done
