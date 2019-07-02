#!/bin/bash 

#working_with_mt_human_dna with name as {number}.vcf

#перевод в формат 4.2 (вроде forсe все-равно его преодолеет)
#но может так лучше
#все утилиты vcf-tools работают с gz и gz.tbi
#дописываем контиг, ибо какая-то прога ругалась вроде

for i in {50..300}
do
if [[ -f ${i}.vcf ]]; then
cat ${i}.vcf | ~/progs/vcftools/src/perl/vcf-convert -v 4.2 > ${i}_4.2.vcf
sed -i 's/##source=VarScan2/##source=VarScan2\n##contig=<ID=chrMT,length=16569>/' ${i}_4.2.vcf

bgzip ${i}_4.2.vcf
tabix -p vcf ${i}_4.2.vcf.gz 

# находим и записываем совпадения позиций (?) в первом файле с бд и оставляем алелли файла

~/progs/vcftools/src/perl/vcf-isec -f ${i}_4.2.vcf.gz disease_corrected.vcf.gz | bgzip -c > ${i}_diss.vcf.gz
tabix -p vcf ${i}_diss.vcf.gz
gunzip -k ${i}_diss.vcf.gz

#находим алелли этих позиций в бд, чтобы быть уверенным, что они одинаковы

~/progs/vcftools/src/perl/vcf-isec -f disease_corrected.vcf.gz ${i}_diss.vcf.gz | bgzip -c > ${i}_allel_from_db.vcf.gz
tabix -p vcf ${i}_allel_from_db.vcf.gz

#вариант один - сразу смешиваем, тогда где разные аллели
#будет красиво видно в vcf-ке - сначала файла, птом бд

~/progs/vcftools/src/perl/vcf-merge ${i}_diss.vcf.gz ${i}_allel_from_db.vcf.gz > ${i}.disease.vcf

/home/silly/progs/annovar/table_annovar.pl ${i}_diss.vcf /media/silly/Databases/humandb/ -buildver hg19 -out ${i}_dis_snp -remove -protocol avsnp150 -operation f -nastring . -vcfinput
bgzip ${i}_dis_snp.hg19_multianno.vcf
tabix -p vcf ${i}_dis_snp.hg19_multianno.vcf.gz

#вариант два - пришиваем rs а затем мешаем
#почему-то тогда алелли мешаются...

~/progs/vcftools/src/perl/vcf-merge ${i}_dis_snp.hg19_multianno.vcf.gz ${i}_allel_from_db.vcf.gz > ${i}.disease_rs.vcf


##https://askubuntu.com/questions/531271/how-to-delete-second-column-in-vim 
##http://vcftools.sourceforge.net/perl_module.html#vcf-isec
#
##resourse
##https://mitomap.org/foswiki/bin/view/MITOMAP/Resources

fi
done

