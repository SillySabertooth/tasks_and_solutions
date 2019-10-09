

rule bam_stats:
    input: "{id}_Srt.bam"
    output: "reports/bam_s/{id}.bc", "reports/bam_s/{id}.log"
    shell: "samtools stats {input} > {output[0]}; samtools stats {input} > {output[1]}"


#$Path_to_pr/samtools-1.5/misc/plot-bamstats ${i}.m_sort_bam.bc -p ${i}_bamstats_plots/

