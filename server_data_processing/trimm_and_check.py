
IDS, = glob_wildcards("{id}_R1_001.fastq.gz")
PathDtb = "/storage/analysis/Databases"

rule all:
    input: expand("reports/trimmomatic/fast_qc/{id}.R2_paired_fastqc.html", id=IDS)

rule fastQC:
    input: "analysis/trimmed/{id}.R1_paired.fastq.gz", "analysis/trimmed/{id}.R2_paired.fastq.gz"
    output: "reports/trimmomatic/fast_qc/{id}.R1_paired_fastqc.html", "reports/trimmomatic/fast_qc/{id}.R2_paired_fastqc.html"
    shell: "/storage/analysis/progs/FastQC/fastqc -o ./reports/trimmomatic/fast_qc/ -f fastq {input}"


rule trimmomatic_pe:
    input: "{id}_R1_001.fastq.gz", "{id}_R2_001.fastq.gz"
    output: "analysis/trimmed/{id}.R1_paired.fastq.gz", "analysis/trimmed/{id}.R1_unpaired.fastq.gz", "analysis/trimmed/{id}.R2_paired.fastq.gz", "analysis/trimmed/{id}.R2_unpaired.fastq.gz"
    log: "reports/trimmomatic/{id}.log"
    shell: "(java -jar /storage/analysis/progs/Trimmomatic-0.39/trimmomatic-0.39.jar PE {input} {output} ILLUMINACLIP:/storage/analysis/progs/Trimmomatic-0.39/adapters/NexteraPE-PE.fa:2:30:10 LEADING:5 TRAILING:5 SLIDINGWINDOW:4:15 MINLEN:35 CROP:73 HEADCROP:15) 2>> {log}"



