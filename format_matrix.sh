#!/bin/bash
#usage:
#	sh format_matirix.sh <my_project.csv>

#input is output from load_TC.py

sed 's/^[0-9]\+\?,//' $1 | 
sed '1d' | 
sed 's/,/\t/g' | 
sed "s/'//g" | 
sed 's/://g' | 
sed 's/\t-/\t/g' | 
sed 's/Theme /Theme_/' | 
sed 's/Theme_[0-9]\+/&\t/' | 
sed 's/ \+/\t/g' | 
sed -E 's/\t[0-9]/\t/g' | 
sed 's/\t"{//g' | 
sed 's/ /\t/g' | 
sed 's/\.//g'  | 
sed 's/\t[0-9]*\t/\t/g' | 
sed 's/\t[0-9]*\t/\t/g' |
sed 's/\t[0-9]*\t/\t/g' |
sed 's/\t[0-9]*/\t/g' | 
sed 's/}"//g' > output
./transpose.exe output > $1.out
sed -i '/^$/d' $1.out
sed -i 's/\t/\t1\t/g' $1.out
sed -i 's/$/\t1/' $1.out
rm output
