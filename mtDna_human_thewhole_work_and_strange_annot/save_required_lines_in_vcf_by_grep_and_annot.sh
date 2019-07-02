#!bin/bash

for i in {1..255}
do
if [[ -f ${i}.vcf ]]; then
grep -w "^#*\|^#CHROM\|^chrMT" ${i}.vcf > ${i}_clean.vcf

Path_to_pr=/home/donat/Pipe/programms
$Path_to_pr/annovar/table_annovar.pl ${i}_clean.vcf /media/donat/Databases/humandb/ -buildver hg19 -out ./${i}_mt -remove -protocol avsnp150,clinvar_20170501,revel,mitimpact24 -operation f,f,f,f -nastring . -vcfinput
fi
done

