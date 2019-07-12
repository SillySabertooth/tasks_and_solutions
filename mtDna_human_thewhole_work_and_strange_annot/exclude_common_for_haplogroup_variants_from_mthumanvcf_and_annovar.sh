#!bin/bash

#i made that so much time ago
#i hope now that bwa mem of two fasta files is not definitely bad way for defining variants of haplogroups; of course it's not the good solution
#a few days ago i used bwa bwasw - you can try it; but i will not make changes in that script

for i in {1..300}
do
if [[ -f ${i}_1.fasta ]]; then

#every haplogroup is defining by 2 fasta files from 2 representing this haplogroup humans
cat ${i}_1.fasta > ${i}_hpmt.fasta
cat ${i}_2.fasta >> ${i}_hpmt.fasta #i think in that place should be >>, not >; and i changed that; u should check that cause i removed by incidient data and i can't check this now 
~/progs/bwa-0.7.17/bwa mem rCRS.fasta ${i}_hpmt.fasta > ${i}.sam

~/progs/samtools-1.5/samtools view ${i}.sam -o ${i}.bam
~/progs/samtools-1.5/samtools sort ${i}.bam -o ${i}.s.bam
~/progs/samtools-1.5/samtools index ${i}.s.bam
~/progs/samtools-1.5/samtools mpileup -uvf rCRS.fasta ${i}.s.bam | ~/progs/bcftools-1.5/bcftools call -cv -> ${i}_hpmt.vcf
~/progs/vcftools/src/cpp/vcftools --vcf ${i}_hpmt.vcf --remove-indels --recode --recode-INFO-all --out ${i}_hpmt_snp.vcf
~/progs/vcflib/bin/vcffilter -f "AC1 = 2 " ${i}_hpmt_snp.vcf.recode.vcf > ${i}_MT.vcf #unical, shared by both
#above we obtained the ref_vcf_file for the sample's haplogroup using existing 2 fasta files, that defining the specific haplogroup in db
#below we'll compare our vcf file with obtained_ref_vcf_file to exclude common for sample's haplogroup variants 
#converting and pre-processing
cat ${i}_MT.vcf | ~/progs/vcftools/src/perl/vcf-convert -v 4.2 > ${i}_MT_4.2.vcf

bgzip ${i}_MT_4.2.vcf
gunzip -k ${i}_MT_4.2.vcf
tabix -p vcf ${i}_MT_4.2.vcf.gz

#comparing
~/progs/jvarkit/dist/vcfin -i -A ../${i}_4.2.vcf.gz -D ${i}_MT_4.2.vcf.gz > ${i}.not_anno_indiv.vcf
#and annotating them
/home/silly/progs/annovar/table_annovar.pl ${i}.not_anno_indiv.vcf /media/silly/Databases/humandb/ -buildver hg19 -out ${i}_individual -remove -protocol avsnp150,clinvar_20170501,mitimpact24 -operation f,f,f -nastring . -vcfinput
fi
done

