#!/bin/bash

read vcf

for file in $vcf; do
  for sample in `~/progs/bcftools-1.5/bcftools query -l $file`; do
    ~/progs/bcftools-1.5/bcftools view -c1 -Oz -s $sample -o ${file/.vcf*/.$sample.vcf.gz} $file
  done
done

https://www.biostars.org/p/78929/
