SAMPLES, = glob_wildcards("analysis/bam_s/{sample}_L001_Srt.bam")
PathDtb = "/storage/analysis/Databases"
Bams="analysis/bam_s/"

rule all:
    input: expand("reports/{sample}/{sample}_Frb.filt.vcf", sample=SAMPLES)

rule filter_frb:
    input: "reports/{sample}/{sample}_Frb.vcf"
    output: "reports/{sample}/{sample}_Frb.filt.vcf"
    shell: "bcftools filter -e 'QUAL<=20' {input} | bcftools filter -i 'FORMAT/DP>=8 & FORMAT/AO>=4' -o {output}"

rule freebayes:
    input: ref="/storage/analysis/Databases/Ref/GRCh37_only_chr.fna", bam="reports/{sample}/{sample}_Srt.bam", bed="../exome_oksana_plus_51_MT.bed"
    output: protected("reports/{sample}/{sample}_Frb.vcf")
    log: "reports/calling/{sample}_Frb.log"
    shell: "/storage/analysis/progs/freebayes/bin/freebayes -f {input.ref} {input.bam} -t {input.bed} | /storage/analysis/progs/vcflib/bin/vcfallelicprimitives -kg > {output}"

rule sort_bam:
    input: "analysis/{sample}/{sample}_Mrk.bam"
    output: protected("reports/{sample}/{sample}_Srt.bam")
    log: "analysis/processing/{sample}_Srt.log"
    shell: "(java -Xms5g -Xmx7g -jar /storage/analysis/progs/picard/build/libs/picard.jar SortSam INPUT={input} OUTPUT={output} SORT_ORDER=coordinate CREATE_INDEX=TRUE) 2>> {log}"

rule mark_duplicates:
    input: "analysis/{sample}/{sample}_RG.bam"
    output: temp("analysis/{sample}/{sample}_Mrk.bam"), "analysis/{sample}/{sample}_MrkDup_metrics.txt"
    log: "analysis/processing/{sample}_Mrt.log"
    shell: "(java -Xms5g -Xmx7g -jar /storage/analysis/progs/picard/build/libs/picard.jar MarkDuplicates I={input} O={output[0]} M={output[1]} REMOVE_DUPLICATES=True) 2>> {log}"


##some of that information is imagination product
rule add_RG:
    input: "analysis/{sample}/{sample}.bam"
    output: temp("analysis/{sample}/{sample}_RG.bam")
    log: "analysis/processing/{sample}_RG.log"
    shell: "(java -jar /storage/analysis/progs/picard/build/libs/picard.jar AddOrReplaceReadGroups I={input[0]} O={output} SORT_ORDER=coordinate RGID=NB551549 RGLB=Nextera_CD_DNA RGPL=ILLUMINA RGPU=NB551549000000000-H5VHFBGXB RGSM={wildcards.sample} CREATE_INDEX=False) 2>> {log}"


rule merge:
    input: Bams+"{sample}_L001_Srt.bam", Bams+"{sample}_L002_Srt.bam",Bams+"{sample}_L003_Srt.bam", Bams+"{sample}_L004_Srt.bam"
    output: protected("analysis/{sample}/{sample}.bam")
    threads: 6
    shell: "samtools merge -@ {threads} {output} {input}"

