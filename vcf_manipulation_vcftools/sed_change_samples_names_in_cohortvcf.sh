#!bin/bash

#primitive, yep

for i in {1..600}
do 
sed -i "s/\/media\/sf_Biolinux_folder_E\/illumina\/fastq_0[0-9]_18\/BAMs\/${i}.m.sort.bam/${i}.m.sort.bam/" all_by_excel_from_72_samples.vcf
done


