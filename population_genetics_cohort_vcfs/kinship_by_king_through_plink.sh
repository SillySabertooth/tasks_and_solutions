#!/bin/bash

#this commands are from Vasili Pankratov vasilipankratov@gmail.com 
#but i make a loops

name=real_brothers
final=bros

#сливаем все vcf (1 образец = 1 vcf) в папке в один

~/progs/vcftools/src/perl/vcf-merge -R 0/0 *.vcf.gz > ${name}.vcf

# bgzip и индексирование
bgzip -c ${name}.vcf > ${name}.vcf.gz
tabix -p vcf ${name}.vcf.gz

#делаем формат для плинка
~/progs/vcftools/src/cpp/vcftools --gzvcf ${name}.vcf.gz --plink-tped --out ${name}

#делаем формат для кинга - в обоих случаях в аут идет префикс
~/progs/plink/plink --tfile ${name} --noweb --make-bed --out ${name}

#ну и сам кинг запускается на родство
~/progs/king -b ${name}.bed --kinship --prefix ${final}
###~/progs/king -b ${name}.bed --homog --prefix ${final}

