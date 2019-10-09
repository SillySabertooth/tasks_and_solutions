#!/bin/bash
Path=~/NGS/pipeline_new/check_snakemake_gatk
cd $Path
Db=/media/silly/Databases/
Progs=/home/silly/progs/
Name=man_thats_your_cohort

###надо сначала сделать геномик_карту
touch cohort.sample_map
for n in $(ls *g.vcf.gz)
i=${n%.g.vcf.gz}
do
echo "${i}	$Path/${i}.g.vcf.gz" >> cohort.sample_map
done 

##################################
#
#echo "Если у вас маленькая выборка - общее генотипирование и фильтрация не даст преимещуств; рекомендуется скачать как минимум bam файлов и сделать на них gvcf"
####GenomicsDBimport - сливаем все наши образцы в кучу; если ваша выборка мала - нужно скачать с 1000 геномов сырых файлов для увеличения выборки и обрабатывать их вместе; мало того - скачать стоит как минимум бам-файлы, а не gvcf
#$Progs/gatk-4.1.1.0/gatk --java-options "-Xmx8g -Xms6g" GenomicsDBImport \
#   --genomicsdb-workspace-path $Path/genomic_db \
#   --sample-name-map cohort.sample_map \
#   --reader-threads 2 \
#   -L chr1 -L chr2 -L chr3 -L chr4 -L chr5 -L chr6 -L chr7 -L chr8 -L chr9 -L chr10 -L chr11 -L chr12 -L chr13 -L chr14 -L chr15 -L chr16 -L chr17 -L chr18 -L chr19 -L chr20 -L chr21 -L chr22 -L chrX -L chrY -L chrMT \
#   --batch-size 20
#
##а теперь вместе генотипируем
#$Progs/gatk-4.1.1.0/gatk --java-options "-Xmx8g -Xms6g" GenotypeGVCFs \
#    -R $Db/Ref/GRCh37_by_hand.fna \
#    -V gendb://$Path/genomic_db \
#    -G StandardAnnotation --new-qual True \
#    -O ${Name}_raw.vcf 
##теперь самое сложное и самое важное - построение моделей для фильтрации;  для снипов и инделов соответсвенно  
#$Progs/gatk-4.1.1.0/gatk --java-options "-Xmx8g -Xms6g" VariantRecalibrator \
#    -R $Db/Ref/GRCh37_by_hand.fna \
#    -V ${Name}_raw.vcf \
#    --resource:hapmap,known=false,training=true,truth=true,prior=15.0 $Db/gatk_db/hapmap_3.3.hg19.sites.vcf \
#    --resource:omni,known=false,training=true,truth=false,prior=12.0 $Db/gatk_db/1000G_omni2.5.hg19.sites.vcf \
#    --resource:1000G,known=false,training=true,truth=false,prior=10.0 $Db/gatk_db/1000G_phase1.snps.high_confidence.hg19.sites.vcf \
#    --resource:dbsnp,known=true,training=false,truth=false,prior=2.0 $Db/gatk_db/dbsnp_138.hg19.vcf \
#    -an QD -an MQ -an MQRankSum -an ReadPosRankSum -an FS -an SOR -an InbreedingCoeff \
#    -mode SNP \
#    -O ${Name}_snp.recal \
#    --tranches-file ${Name}_snp.tranches \
#    --rscript-file ${Name}_snp.plots.R \
#    --max-gaussians 4
##-an InbreedingCoeff - if >10 and not related
#
#
#$Progs/gatk-4.1.1.0/gatk --java-options "-Xmx8g -Xms6g" VariantRecalibrator \
#    -R $Db/Ref/GRCh37_by_hand.fna \
#    -V ${Name}_raw.vcf \
#    --resource:mills,known=false,training=true,truth=true,prior=12.0 $Db/gatk_db/Mills_and_1000G_gold_standard.indels.hg19.sites.vcf \
#    --resource:dbsnp,known=true,training=false,truth=false,prior=2.0 $Db/gatk_db/dbsnp_138.hg19.vcf \
#    -an QD -an FS -an SOR -an ReadPosRankSum -an MQRankSum -an InbreedingCoeff \
#    -mode INDEL \
#    -O ${Name}_indel.recal \
#    --tranches-file ${Name}_indel.tranches \
#    --rscript-file ${Name}_indel.plots.R \
#    --max-gaussians 4
##
####Ну и применение этих фильтров-моделей
#$Progs/gatk-4.1.1.0/gatk --java-options "-Xmx8g -Xms6g" ApplyVQSR \
#    -R $Db/Ref/GRCh37_by_hand.fna \
#    -V ${Name}_raw.vcf \
#    -O ${Name}_snp_filtered.vcf.gz \
#    --truth-sensitivity-filter-level 99.0 \
#    --tranches-file ${Name}_snp.tranches \
#    --recal-file ${Name}_snp.recal \
#    -mode SNP
#
#
#$Progs/gatk-4.1.1.0/gatk --java-options "-Xmx8g -Xms6g" ApplyVQSR \
#    -R $Db/Ref/GRCh37_by_hand.fna \
#    -V ${Name}_raw.vcf \
#    -O ${Name}_indel_filtered.vcf.gz \
#    --truth-sensitivity-filter-level 99.0 \
#    --tranches-file ${Name}_indel.tranches \
#    --recal-file ${Name}_indel.recal \
#    -mode INDEL
#
