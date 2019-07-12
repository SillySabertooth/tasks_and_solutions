#!bin/bash

#в файле seq_id лежат разбитые пробелом идентификаторы
#копируем общий feature table вверх
#идем за ним и дописываем ему айди; изначально у общего файла я удалил айди
#обратно в папку; потом все в один сливаем; это все нужно было для заливания сильно схожих сиквенсов в ncbi

for i in $(cat seq_id.txt)
do
#rm all after first space
#adding modificators
cp mito_feature.txt ../${i}.txt
cd ..
sed -i "1 s/$/ ${i}/" ${i}.txt
sed -i -e "s/\r//g" ${i}.txt
cd scripts_and_ftb
done

cd ..
cat *.txt >> all_features.txt

