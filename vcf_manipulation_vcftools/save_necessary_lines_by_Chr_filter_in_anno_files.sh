#!bin/bash

#оставляем то, что начинается либо с Chr, либо с Chr7 / Chr17
#внимание - это уже не всф файл - хоть формальная проверка идет через него
for i in {1..100}
do
if [[ -f ${i}_varscan.vcf ]]; then
grep -w "^Chr\|^chr7\|^chr17" ${i}_anno.hg19_multianno.txt > ${i}_anno.txt
fi
done


