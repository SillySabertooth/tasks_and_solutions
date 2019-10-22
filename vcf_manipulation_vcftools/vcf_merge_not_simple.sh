for dir in 10_S8 16_S9 19_S12 2_S2 5_S4 7_S6 14_S10 17_S11 1_S1 3_S3 6_S5 8_S7
do
cd $dir

<${dir}_Frb.filt.vcf /storage/analysis/progs/vcflib/bin/vcfsnps | /storage/analysis/progs/vcflib/bin/vcfbiallelic >${dir}_biall.Frb.filt.vcf

sed -i "/#CHROM/ s/${dir}/${dir}_Frb/" ${dir}_biall.Frb.filt.vcf
sed -i "/#CHROM/ s/${dir}/${dir}_Btc/" ${dir}_Btc.filt.vcf
sed -i "/#CHROM/ s/${dir}/${dir}_Vs2/" ${dir}_Vs2.vcf
sed -i "/FORMAT=<ID=AD/ s/Number=R/Number=./" ${dir}_biall.Frb.filt.vcf
sed -i "/FORMAT=<ID=AO/ s/Number=A/Number=./" ${dir}_biall.Frb.filt.vcf
sed -i "/FORMAT=<ID=QA/ s/Number=A/Number=./" ${dir}_biall.Frb.filt.vcf
sed -i "/FORMAT=<ID=GL/ s/Number=G/Number=./" ${dir}_biall.Frb.filt.vcf

for i in ${dir}_Btc.filt.vcf ${dir}_Vs2.vcf ${dir}_biall.Frb.filt.vcf

do
bgzip -c ${i} > ${i}.gz
tabix -p vcf ${i}.gz
done


bcftools merge -0 -m all *.vcf.gz -o ${dir}_all_callers.vcf

cd ../
done
