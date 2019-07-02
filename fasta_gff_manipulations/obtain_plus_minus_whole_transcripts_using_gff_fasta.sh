#!/bin/bash
#надо быть аккуратным и прогуглить/проверить на всяк сулчай
#вроде gffread не просто накладывает координаты на фасту, а смотрит на + и - цепь и возвращает именно необхоидмый транксрипт

read name 
#whole_tr
~/progs/gffread-0.10.8/gffread -w ${name}_whole_tr_with_names.fasta -g ${name}.fasta ${name}.gff3
sed '/^>/ d' < ${name}_whole_tr_with_names.fasta > ${name}_whole_tr.fasta

#whole_gen_1
#отбираются нужные строки в аннотации, затем подаются в gffread - как итог, получаем транксрипты по аннотации
awk -F'\t' '$7~/\+/' ${name}.gff3 > ${name}_plus_whole.gff3
awk -F'\t' '$7~/\-/' ${name}.gff3 > ${name}_mins_whole.gff3
#
#
~/progs/gffread-0.10.8/gffread -w ${name}_plus_whole_with_names.fasta -g ${name}.fasta ${name}_plus_whole.gff3
~/progs/gffread-0.10.8/gffread -w ${name}_mins_whole_with_names.fasta -g ${name}.fasta ${name}_mins_whole.gff3

sed '/^>/ d' < ${name}_plus_whole_with_names.fasta > ${name}_plus_whole.fasta
sed '/^>/ d' < ${name}_mins_whole_with_names.fasta > ${name}_mins_whole.fasta


