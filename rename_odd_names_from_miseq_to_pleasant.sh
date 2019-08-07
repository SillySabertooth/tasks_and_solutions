#!/bin/bash

#очень древнняя штука; не помню, почему не sed
#странно раотает; но работает ведь!
#
#read Numb
#for i in $(seq 1 $Numb)
#do
#for R in 1 2
#do
#rename "s/${i}_S[0-9]*_L001_R${R}_001.fastq.gz/${i}.R${R}.fastq.gz/" *
#done
#done
#
###теперь работает не только для цифр
for n in $(ls *.fastq.gz)
do
i="${n%_*_*_*_*}"
echo ${i}
for R in 1 2
do
rename "s/${i}_S[0-9]*_L001_R${R}_001.fastq.gz/${i}.R${R}.fastq.gz/" *
done
done

