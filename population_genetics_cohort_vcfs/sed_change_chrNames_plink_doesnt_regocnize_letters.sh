#!bin/bash

#походу плинk или кинг не жрут буквенные названия хромосом - стоит их сделать цифрами

#sed -i '/^chrUn*/dg' ./all_for_add.vcf

for i in {1..22}
do
sed -i "s/chr${i}/${i}/" ./all_for_add.vcf
done


sed -i "s/chrX/23/" ./all_for_add.vcf
sed -i "s/chrY/24/" ./all_for_add.vcf
sed -i "s/chrM/25/" ./all_for_add.vcf
sed -i "s/chrUn_gl000220/26/" ./all_for_add.vcf
