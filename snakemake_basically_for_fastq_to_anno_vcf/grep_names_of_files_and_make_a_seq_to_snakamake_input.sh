#!/bin/bash

#надо выбрать те файлы, которые мы считаем в нижнем ls, тут - sh
pl=$(ls *sh)

for i in $pl; do

filename=${i%.*}
string+=$filename
string+=","

done
echo $string


################################################################################################


#Assuming that the elements do not contain spaces, you could translate spaces to commas:
#You can also use ranges with characters:
#echo a{b..d} | tr ' ' ,

#filename=
#$ s=/the/path/foo.txt
#$ echo ${s##*/}
#foo.txt
#$ s=${s##*/}
#$ echo ${s%.txt}
#foo
#$ echo ${s%.*}
#foo
