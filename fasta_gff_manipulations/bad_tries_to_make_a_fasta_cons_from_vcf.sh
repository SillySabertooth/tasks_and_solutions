#!/bin/bash

#тут все ясно - сначала делаем bam и vcf, потом пытаемся сделать fasta; но что-то было не так и я забил
Path_to_pr=/home/silly/progs

$Path_to_pr/samtools-1.5/samtools view -b 2.m.sort.bam chrMT > 2.mt.bam
$Path_to_pr/samtools-1.5/samtools sort 2.mt.bam
$Path_to_pr/samtools-1.5/samtools index 2.mt.bam


#$Path_to_pr/samtools-1.5/samtools mpileup -uf /media/silly/Databases/Ref/GRCh37_by_hand.fna 2.mt.bam | $Path_to_pr/bcftools-1.5/bcftools call -c | $Path_to_pr/bcftools-1.5/misc/vcfutils.pl vcf2fq > 2.fastq


#$Path_to_pr/samtools-1.5/samtools mpileup -f /media/silly/Databases/Ref/GRCh37_by_hand.fna 2.mt.bam | java -jar $Path_to_pr/VarScan.v2.3.9.jar mpileup2cns --p-value 99e-15 | $Path_to_pr/bcftools-1.5/misc/vcfutils.pl vcf2fq > 2_a.fastq

#$Path_to_pr/seqtk/seqtk seq -aQ64 -q20 -n N 2.fastq > 2.fasta

samtools mpileup -uf ref.fa aln.bam | bcftools call -mv -Oz -o calls.vcf.gz tabix calls.vcf.gz cat ref.fa | bcftools consensus calls.vcf.gz > cns.fa


https://github.com/samtools/samtools/issues/899
