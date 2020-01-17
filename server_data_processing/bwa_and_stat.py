IDS, = glob_wildcards("analysis/trimmed/{id}.R2_paired.fastq.gz")
PathDtb = "/storage/analysis/Databases"
Bams="analysis/bam_s/"

rule all:
    input: expand("reports/bam_s/{id}.bc", id=IDS)

### i don't like it
###rule i_forget:
###    input: "reports/bam_s/{id}.bc"
###    output: "reports/bam_s/bamstats_plots/{id}.html"
###    shell: "plot-bamstats {input} -p reports/bam_s/bamstats_plots/{wildcards.id}"

rule bam_stats:
    input: Bams+"{id}_Srt.bam"
    output: "reports/bam_s/{id}.bc", "reports/bam_s/{id}.log"
    shell: "samtools stats {input} > {output[0]}; samtools stats {input} > {output[1]}"

rule sort_bam_for_concat:
    input: Bams+"{id}.bam"
    output: Bams+"{id}_Srt.bam"
    log: "reports/bam_s/{id}_Srt.log"
    shell: "(java -jar /storage/analysis/progs/picard/build/libs/picard.jar SortSam INPUT={input} OUTPUT={output} SORT_ORDER=coordinate CREATE_INDEX=TRUE) 2>> {log}"


rule bwa_samtools:
    input: Ref=PathDtb+"/Ref/GRCh37_only_chr.fna", R1="analysis/trimmed/{id}.R1_paired.fastq.gz", R2="analysis/trimmed/{id}.R2_paired.fastq.gz"
    output: Bams+"{id}.bam"
    log: "reports/bam_s/{id}_bwa.log"
    threads: 6
    shell: "(bwa mem -t {threads} {input.Ref} {input.R1} {input.R2} | samtools view -Sb > {output}) 2>> {log}"


