#!/bin/bash

set -euo pipefail

#штуке сверху меня научили в питере 05.19 - очень удобно
#bwasw - алгоритм bwa при выравнивании длинных последовательностей
#дальше все стандартно - sam -> bam -> vcf
for f in $(ls *fa)
do
i="${f%.*}"

bwa bwasw chloroplast_Saski.fasta ${i}.fa > ./Results/${i}.sam 

cd Results/

samtools view ${i}.sam -o ${i}.bam
samtools sort ${i}.bam -o ${i}.s.bam
samtools index ${i}.s.bam

cd ..

~/progs/samtools-1.5/samtools mpileup -uvf ../chloroplast_Saski.fasta ${i}.s.bam | ~/progs/bcftools-1.5/bcftools call -cv -> ${i}.vcf
cd ..

done
#
#cd Results/

#~/progs/samtools-1.5/samtools mpileup -uvf ../chloroplast_Saski.fasta *.s.bam | ~/progs/bcftools-1.5/bcftools call -cv -> all_samples.vcf

