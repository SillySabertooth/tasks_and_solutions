#!/bin/bash
for i in {1..255}
do
if [[ -f ${i}.m.sort.bam ]]; then

#сама команда и замена записи на имя образца + стакование в общий файл
java -jar /home/silly/progs/haplogrep-2.1.18.jar --in ${i}.vcf --format vcf --out ${i}.txt
sed -i "s/"Sample1"/"${i}"/g" ${i}.txt
sed -n '2p' ${i}.txt >> all.haplogroups_of_samples.txt 
fi
done

