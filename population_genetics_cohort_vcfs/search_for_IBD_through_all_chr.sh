#!/bin/bash

#васина базисная команда
#java -Xms2000m -Xmx6000m -jar ~/Vasya/ibdseq.r1206.jar gt=all_72.chr2.recode.vcf nthreads=3 out=chr2_work_bad
#добавил переход в папку и вытягивание файлов из ../ 
#не запускал, надеюсь, работает

mkdir ./ibdseq_res
cd ./ibdseq_res

for i in {1..22}
do
java -Xms2000m -Xmx6000m -jar ~/Vasya/ibdseq.r1206.jar gt=../chr${i}.vcf nthreads=3 ibdlod=3.0 out=chr${i}
done

for i in X Y M Un_gl000220
do
java -Xms2000m -Xmx6000m -jar ~/Vasya/ibdseq.r1206.jar gt=../chr${i}.vcf nthreads=3 ibdlod=3.0 out=chr${i}
done


