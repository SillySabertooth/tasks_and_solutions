mkdir -p ./reports/fast_qc_check/
/storage/analysis/progs/FastQC/fastqc -o ./reports/fast_qc_check/ -t 19 -f fastq *fastq.gz
cd ./reports/fast_qc_check/
multiqc .
