SAMPLES, = glob_wildcards("analysis/bam_s/{sample}_L001_Srt.bam")

rule all:
    input: expand("reports/{sample}/{sample}_Frb.vcf", "reports/{sample}/{sample}_Vs2.vcf", "reports/{sample}/{sample}_Btc.vcf", sample=SAMPLES)


#rule filter_bcf_and_frb_called_vcf:
#    input: "{sample}.Frb.vcf", "{sample}.Btc.vcf"
#    output: "{sample}.Frb.filt.vcf", "{sample}.Btc.filt.vcf"
#    shell: "bcftools filter -e 'QUAL<=10' -o {output[0]} {input[0]}; bcftools filter -e 'QUAL<=10' -o {output[1]} {input[1]} " 
#
##bcftools filter -s LOWQUAL -i %QUAL>10 -o 13.Frb.filt.vcf 13.Frb.vcf
#bcftools filter -i FILTER=='PASS' -o 13.Frb.filt.pass.vcf 13.freb.filt.areg.vcf

rule freebayes:
    input: "../Databases/Ref/GRCh37_by_hand.fna", "reports/{sample}/{sample}_Srt.bam"
    output: "reports/{sample}/{sample}_Frb.vcf"
    shell: "../progs/freebayes/bin/freebayes -f {input} | ../progs/vcflib/bin/vcfallelicprimitives -kg > {output}"

rule bcftools_call:
    input: "../Databases/Ref/GRCh38_by_hand.fna", "reports/{sample}/{sample}_Srt.bam"
    output: protected("reports/{sample}/{sample}_Bct.vcf")
    log: "reports/calling/{sample}_Bct.log"
    shell: "samtools mpileup -u -t DP -f {input} | bcftools call -v -c -f GQ -> {output}"

#samtools mpileup -l merged_regions.plus50bp.A_part.bed -u -t DP -f ref.fa 13.bam
#bcftools call -v -c -f GQ -


#freebayes -t regions.A_part.bed -f ref.fa bam
#bcftools concat -a -f 13.Frb.vcf.splitlist -Ov -o 13.Frb.vcf
#it can be two ways how they splited the files 1) by Chr 2) by regions
#i think it was the second one. or smt between. so, in the splitlist - names of vcf tol concating 

rule varscan2:
    input: "../Databases/Ref/GRCh37_by_hand.fna", "reports/{sample}/{sample}_Srt.bam"
    output: protected("reports/{sample}/{sample}_Vs2.vcf")
    log: "reports/calling/{sample}_Vs2.log"
    shell: "(samtools mpileup -f {input} | java -jar ../progs/VarScan.v2.3.9.jar mpileup2cns --output-vcf 1 --variants > {output}) 2>> {log}"

