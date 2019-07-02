#!/bin/bash

Path_short=/home/silly/Larissa/larissa_01_19/raw_data
Db=/media/silly/Databases/
Progs=/home/silly/progs/
echo 'введите номер верхнего образца; и посмотрите на тело скрипта прежде чем запускать; могут быть exceptions - я изменял имена файлов и добавил опцию без последующего запуска - если реально будет падать, то легко пофиксятся ошибки; работало это специально под numeric названия - если чо, можно содрать имена через for i in $(ls *fastq.gz) и затем уже в цикле отрезать суффиксы через f="${i%.*}'
read Numb

for i in $(seq 1 $Numb)
do
for R in 1 2
do
rename "s/${i}_S[0-9]*_L001_R${R}_001.fastq.gz/${i}.R${R}.fastq.gz/" *
done
done

mkdir Results
mkdir $Path_short/Results/fastqc_res
for i in 105
#for i in {1..100}
do
if [[ -f $Path_short/${i}.R1.fastq.gz ]]; then

mkdir $Path_short/${i}
Path=$Path_short/${i}
cd $Path

##########################Pre-pre-processing

### Trimm

java -jar $Progs/Trimmomatic-0.38/trimmomatic-0.38.jar \
PE \
../${i}.R1.fastq.gz \
../${i}.R2.fastq.gz \
${i}.R1_paired.fastq \
${i}.R1_unpaired.fastq \
${i}.R2_paired.fastq \
${i}.R2_unpaired.fastq \
ILLUMINACLIP:$Progs/Trimmomatic-0.38/adapters/TruSeq3-PE-2.fa:2:30:10 LEADING:5 TRAILING:5 SLIDINGWINDOW:4:15 MINLEN:45

### FastQC
$Progs/FastQC/fastqc -o $Path_short/Results/fastqc_res -f fastq ./${i}.R1_paired.fastq ./${i}.R2_paired.fastq ../${i}.R{1..2}.fastq.gz

############################Mapping

# BWA & Samtools with trim
$Progs/bwa-0.7.17/bwa mem -t 8 $Db/Ref/GRCh37_by_hand.fna \
${i}.R1_paired.fastq ${i}.R2_paired.fastq > ${i}.sam

$Progs/samtools-1.5/samtools view -Sb ${i}.sam > ${i}.bam

## RG_add or need uBam
java -jar $Progs/picard/build/libs/picard.jar AddOrReplaceReadGroups \
    I=${i}.bam \
    O=${i}_RGr.bam \
    SORT_ORDER=coordinate \
    RGID=M02531.1 \
    RGLB=TrueSight-1 \
    RGPL=ILLUMINA \
    RGPU=M0253122000000000-BGFH9.1 \
    RGSM=${i} \
    CREATE_INDEX=True

########################################Mark_and_remove_duplicates раньше не удалялись - добавил опцию, но не запускал, может, синтаксис не такой

## Mark and Sort
java -jar $Progs/picard/build/libs/picard.jar MarkDuplicates \
      I=${i}_RGr.bam \
      O=${i}_MrkDup.bam \
      M=${i}_MrkDup_metrics.txt > $Path/log.txt \
      REMOVE_DUPLICATES=TRUE

java -jar $Progs/picard/build/libs/picard.jar SortSam \
      INPUT=${i}_MrkDup.bam \
      OUTPUT=${i}_Srt.bam \
      SORT_ORDER=coordinate \
      CREATE_INDEX=TRUE 

######################################

$Progs/samtools-1.5/samtools mpileup -f $Db/Ref/GRCh37_by_hand.fna ${i}_Srt.bam | java -jar /home/silly/progs/VarScan.v2.3.9.jar mpileup2cns --output-vcf 1 --variants > ${i}_vrsc.vcf

$Progs/annovar/table_annovar.pl ${i}_vrsc.vcf /media/silly/Databases/humandb/ -buildver hg19 -out ./${i}_an_vrsc -remove -protocol refGene,esp6500siv2_all,avsnp150,clinvar_20170501,revel,intervar_20170202,1000g2015aug_all,1000g2015aug_afr,1000g2015aug_eas,1000g2015aug_eur,gnomad_genome -operation g,f,f,f,f,f,f,f,f,f,f -nastring . -vcfinput

mv ${i}_Srt.bam ${i}_Srt.bai ${i}_vrsc.vcf ${i}_an_vrsc.hg19_multianno.txt ../Results

#$Progs/freebayes/bin/freebayes -f $Db/Ref/GRCh37_by_hand.fna ${i}_Srt.bam >${i}_frbs.vcf
#$Progs/vcflib/bin/vcfallelicprimitives -kg ${i}_frbs.vcf >${i}_simple.vcf
#$Progs/vcflib/bin/vcffilter -f "QUAL > 40 & DP > 2" ${i}_simple.vcf >${i}_frbs_filtered.vcf

#$Progs/annovar/table_annovar.pl ${i}_frbs_filtered.vcf /media/silly/Databases/humandb/ -buildver hg19 -out ./${i}_an_frbs_filtered -remove -protocol refGene,esp6500siv2_all,avsnp150,clinvar_20170501,revel,intervar_20170202,1000g2015aug_all,1000g2015aug_afr,1000g2015aug_eas,1000g2015aug_eur,gnomad_genome -operation g,f,f,f,f,f,f,f,f,f,f -nastring . -vcfinput


#mv ${i}_Srt.bam ${i}_Srt.bai ${i}_frbs.vcf ${i}_frbs_filtered.vcf ${i}_an_frbs.hg19_multianno.txt ../Results

rm *.*
cd ../
rmdir ${i}/


fi
done

