#!/bin/bash

# табы имеют смысл, сохраняем только CDS, и + и - цепи в разные файлы
awk -F'\t' '$3~/CDS/' chr3.gff > chr_CDS.gff
awk -F'\t' '$7~/\+/' chr_CDS.gff > chr_CDS_plus.gff
awk -F'\t' '$7~/\-/' chr_CDS.gff > chr_CDS_mins.gff
#
#
#накладываем готовые аннотации на референс и получаем последовательности
#но вроде gffread не просто считывает по координатам, но и учитывает +/- -> будут реальные транкрипты в 5->3
~/progs/gffread-0.10.8/gffread -w chr_CDS.fa -g GRCh37_by_hand.fna chr_CDS.gff 
~/progs/gffread-0.10.8/gffread -w chr_CDS_plus.fa -g GRCh37_by_hand.fna chr_CDS_plus.gff 
~/progs/gffread-0.10.8/gffread -w chr_CDS_mins.fa -g GRCh37_by_hand.fna chr_CDS_mins.gff 

sed '/^>/ d' < chr_CDS_plus.fa > chr_CDS_plus_withoit_names.fa
sed '/^>/ d' < chr_CDS_mins.fa > chr_CDS_mins_withoit_names.fa



