#!/bin/bash


for i in {1..200}
do
if [[ -e ${i}.bam ]]; then

java -jar /home/donat/bio_inf/pic/picard/build/libs/picard.jar SamToFastq I=${i}.bam FASTQ=${i}.R1.fastq SECOND_END_FASTQ=${i}.R2.fastq 
else
continue
fi
done


