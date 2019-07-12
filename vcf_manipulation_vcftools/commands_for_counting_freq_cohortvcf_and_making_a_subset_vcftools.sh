#!bin/bash

#vcftools --vcf all_by_excel_from_72_samples.vcf --freq --out freq_all_72_excel

#vcftools --vcf all_by_excel_from_72_samples.vcf --maf 0.35 --max-maf 0.65 --recode --recode-INFO-all --out filtered_35_65

vcftools --vcf all_by_excel_from_72_samples.vcf --maf 0.25 --max-maf 0.75 --recode --recode-INFO-all --out filtered_25_75



