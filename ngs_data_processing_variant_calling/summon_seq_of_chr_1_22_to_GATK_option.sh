#!/bin/bash

len=""
for i in {1..22}
do
len=$len"-L chr$i "
done
len=$len"-L chrX -L chrY -L chrMT \\"
echo $len
