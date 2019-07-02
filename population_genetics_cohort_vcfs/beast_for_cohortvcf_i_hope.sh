#!bin/bash

#фильтранули по частоте
vcftools --vcf all_by_excel_from_72_samples.vcf --maf 0.25 --max-maf 0.75 --recode --recode-INFO-all --out filtered_25_75

#beast стал криво - первая опция это фиксит
#не помню как, но нужно каким-то образом сделать xml
#вроде первое командой лучше всегo вышло
#либо через интерфейсный beast/bin/beauti наверное
#либо через него готовое дерево.. хотя нет, оно открывается beast/lib/DensiTree.jar вроде


###########################################################
mkdir ./beast_result 
cd ./beast_result

#the_line
/home/donat/Vasya/vcf2phylip/vcf2phylip.py -i filtered_25_75.vcf -pn

java -Djava.library.path=/home/donat/lib -jar /home/donat/Vasya/beast/lib/beast.jar ../filtered_25_75.xml

