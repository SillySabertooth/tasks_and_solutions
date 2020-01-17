##i'm sure that for freebayes the steps below are obligatory!
##cause files from freebayes have unusual for bcftools values in some header's fields

for i in `ls *vcf`
do

z=${i%_Frb.filt.vcf}

<${i} ~/progs/vcflib/bin/vcfsnps | ~/progs/vcflib/bin/vcfbiallelic >${z}_bial_frb_filt.vcf

f=${z}_bial_frb_filt.vcf

sed -i "/FORMAT=<ID=AD/ s/Number=R/Number=./" ${f}
sed -i "/FORMAT=<ID=AO/ s/Number=A/Number=./" ${f}
sed -i "/FORMAT=<ID=QA/ s/Number=A/Number=./" ${f}
sed -i "/FORMAT=<ID=GL/ s/Number=G/Number=./" ${f}

bgzip -c ${f} > ${f}.gz
tabix -p vcf ${f}.gz
done

bcftools merge -0 *.vcf.gz -o the_whole.vcf
