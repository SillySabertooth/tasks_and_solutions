Path=/storage/analysis/oksana_exome/191003/
bcl2fastq -o ${Path} --reports-dir ${Path}/Reports --sample-sheet ${Path}/SampleSheet.csv --interop-dir ${Path}/InterOp/ -r 5 -p 5 -w 5
##Inter-op not can be opened for writing
