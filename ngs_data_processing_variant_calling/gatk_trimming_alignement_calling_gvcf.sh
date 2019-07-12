#!/bin/bash

Path_short=/home/silly/Larissa/reanalysis_of_some
Db=/media/silly/Databases/
Progs=/home/silly/progs/
echo "Надеюсь, вы не забыли поменять пути; ежели нет - время Ctrl+c"
echo "Введите верхний номер образца; обработка будет от 1 до \$i образца; паттерн - \$i.R1.fastq.gz"
read Numb
mkdir $Path_short/analgatk
#срнаый гатк может использовать только разархивированные файлы
#поэтому осталась только разваленная сборка

for i in $(seq 1 $Numb)
do
if [[ -f $Path_short/${i}.R1.fastq.gz ]]; then
mkdir $Path_short/analgatk/${i}
Path=$Path_short/analgatk/${i}
cd $Path

##########################Pre-pre-processing

### Trimm

java -jar $Progs/Trimmomatic-0.38/trimmomatic-0.38.jar \
PE \
../../${i}.R1.fastq.gz \
../../${i}.R2.fastq.gz \
${i}.R1_paired.fastq \
${i}.R1_unpaired.fastq \
${i}.R2_paired.fastq \
${i}.R2_unpaired.fastq \
ILLUMINACLIP:$Progs/Trimmomatic-0.38/adapters/TruSeq3-PE-2.fa:2:30:10 LEADING:5 TRAILING:5 SLIDINGWINDOW:4:15 MINLEN:45

### FastQC
mkdir $Path/fastqc_res
$Progs/FastQC/fastqc -o $Path/fastqc_res -f fastq ./${i}.R1_paired.fastq ./${i}.R2_paired.fastq ../${i}.R{1..2}.fastq.gz

############################Mapping

# BWA & Samtools with trim
$Progs/bwa-0.7.17/bwa mem -t 8 $Db/Ref/GRCh37_by_hand.fna \
${i}.R1_paired.fastq ${i}.R2_paired.fastq > ${i}.sam

$Progs/samtools-1.5/samtools view -Sb ${i}.sam > ${i}.bam

## RG_add | need uBam
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

###если у вас есть сырые uBam - стоит использовать их вместо более грубого верхнего варианта
#java -jar $Progs/picard/build/libs/picard.jar MergeBamAlignment \
#  ALIGNED=${i}.bam \
#  UNMAPPED=unmapped.bam \
#  O=${i}_RGr.bam \
#  R=$Db/Ref/GRCh37_by_hand.fna

########################################Mark_duplicates

## Mark and Sort
java -jar $Progs/picard/build/libs/picard.jar MarkDuplicates \
      I=${i}_RGr.bam \
      O=${i}_MrkDup.bam \
      M=${i}_MrkDup_metrics.txt > $Path/log.txt

java -jar $Progs/picard/build/libs/picard.jar SortSam \
      INPUT=${i}_MrkDup.bam \
      OUTPUT=${i}_Srt.bam \
      SORT_ORDER=coordinate \
      CREATE_INDEX=TRUE 

#######################################BQSR

$Progs/gatk-4.1.1.0/gatk BaseRecalibrator \
   -I ${i}_Srt.bam \
   -R $Db/Ref/GRCh37_by_hand.fna \
   --known-sites $Db/gatk_db/dbsnp_138.hg19.vcf \
   --known-sites $Db/gatk_db/Mills_and_1000G_gold_standard.indels.hg19.sites.vcf \
   --known-sites $Db/gatk_db/1000G_phase1.indels.hg19.sites.vcf \
   -O ${i}_Rcl.table

$Progs/gatk-4.1.1.0/gatk ApplyBQSR \
   -R $Db/Ref/GRCh37_by_hand.fna \
   -I ${i}_Srt.bam \
   --bqsr-recal-file ${i}_Rcl.table \
   -O ${i}_Rcl.bam 



### отрисовка опциоальных графиков до/после 
#Generate the first pass recalibration table file - как я понимаю, это я сделал выше

#Generate the second pass recalibration table file

$Progs/gatk-4.1.1.0/gatk BaseRecalibrator \
   -R $Db/Ref/GRCh37_by_hand.fna \
   -I ${i}_Rcl.bam \
   --known-sites $Db/gatk_db/dbsnp_138.hg19.vcf \
   --known-sites $Db/gatk_db/Mills_and_1000G_gold_standard.indels.hg19.sites.vcf \
   --known-sites $Db/gatk_db/1000G_phase1.indels.hg19.sites.vcf \
   -O ${i}_Rcl2.table


#Finally, generate the plots and also keep a copy of the csv (optional)

$Progs/gatk-4.1.1.0/gatk AnalyzeCovariates \
  -before ${i}_Rcl.table \
  -after ${i}_Rcl2.table \
  -plots ${i}_AnlCov.pdf

# и вот это works! эти графики нужно еще переварить
$Progs/gatk-4.1.1.0/gatk AnalyzeCovariates \
   -bqsr ${i}_Rcl.table \
   -plots ${i}_AnlCov_small.pdf

mv ${i}_Rcl.bam ../
mv ${i}_Rcl.bai ../

#Флаг Xmx указывает максимальный пул распределения памяти для виртуальной машины Java (JVM), а Xms указывает начальный пул распределения памяти. Это означает, что ваш JVM будет запущен с объемом памяти Xms и сможет использовать максимум Xmx объема памяти. Например, запуск JVM, как показано ниже, запуститего с 256 МБ памяти и позволит процессу использовать до 2048 МБ памяти: java -Xms256m -Xmx2048m

$Progs/gatk-4.1.1.0/gatk --java-options "-Xms8g -Xmx10g" HaplotypeCaller \
   -R $Db/Ref/GRCh37_by_hand.fna \
   -I ${i}_Rcl.bam \
   -O ${i}.g.vcf.gz \
   -ERC GVCF

fi
done


