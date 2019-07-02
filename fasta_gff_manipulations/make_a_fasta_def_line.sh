#!bin/bash

for i in $(ls *fa)
do
#rm all after the first space - before the first space is the seq_id - we don't care aboit it cause it will be removed after ncbi processing
cut -d ' ' -f 1 < ${i} > temp; cat temp > ${i}
#adding modificators (one there; can be more)
sed -i '1 s/$/ [organism=Hordeum vulgare subsp. vulgare]/' ${i}
sed -i -e "s/\r//g" ${i}

#adding name of fasta = name of file
f="${i%.*}"
s="${f%_mtDNA}"
z=$(echo "Hordeum vulgare subsp. spontaneum alloplasmic line ${s} mitochondrial complete genome")

sed -i "1 s/$/ ${z}/" ${i} 
sed -i -e "s/\r//g" ${i}

done

rm temp
