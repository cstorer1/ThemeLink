#!/usr/bin/bash

#2023.02.26
#chad storer
#launch script for theme comparison
#launch_TC2.sh incorporates addition of auto annotation onto the heatmap
#Usage:
#	sh launch_TC2.sh  <full_path_to_root_Theme_Coordinates.js> <full_path_to_compare_Theme_Coordinates.js>
cd "$(dirname "$0")"

#get full path to *_Theme_Coordinates.js files
ROOT=$1
COMP=$2

#get base names without extension
root_base="$(basename "${ROOT}" .js )"
comp_base="$(basename "${COMP}" .js )"

#get directory names
root_dir="$(dirname "${ROOT}")"
comp_dir="$(dirname "${COMP}")"

#debug stuff----
#echo "ROOT DIR: "$root_dir
#echo "COMP DIR: "$comp_dir
#echo $root_base
#echo $comp_base
#echo $root_dir
#echo $comp_dir

python3 load_TC.py $ROOT
python3 load_TC.py $COMP
#csv files will be made in ROOT and COMP directories

#build fomat_matrix.sh input names
r_fmx="$root_dir""/$root_base"".csv"
c_fmx="$comp_dir""/$comp_base"".csv"

#build theme_compare.py input names
r_tc="$root_dir""/$root_base"".csv.out"
c_tc="$comp_dir""/$comp_base"".csv.out"

#debug stuff----
#echo "root format_matrix in:	"$r_fmx
#echo "comp format_matrix in:	"$c_fmx
#echo "root tc in:		"$r_tc
#echo "comp tc in:		"$c_tc

sh format_matrix.sh $r_fmx
sh format_matrix.sh $c_fmx

#creating local copies of theme matricies
cp $r_tc  .
cp $c_tc  .
loc_r_tc="$(basename "${r_tc}")"
loc_c_tc="$(basename "${c_tc}")"

#build autoannotation file locations to pass to pull_annot.sh
root_annot="$root_dir""/""$(echo "$root_base" | sed "s/_Theme_Coordinates/_Auto_Annotation.txt/")"
comp_annot="$comp_dir""/""$(echo "$comp_base" | sed "s/_Theme_Coordinates/_Auto_Annotation.txt/")"
#echo "debug launch_TC2.sh: root_annot_base: "$root_annot
#echo "debug launch_TC2.sh: comp_annot_base: "$comp_annot


sh pull_annot.sh $root_annot
sh pull_annot.sh $comp_annot

#get name of local annotation files to pass to theme_compare
loc_root_annot="$(echo "$root_base" | sed "s/_Theme_Coordinates/_Auto_Annotation.t_annot/")"
loc_comp_annot="$(echo "$comp_base" | sed "s/_Theme_Coordinates/_Auto_Annotation.t_annot/")"
#echo "debug launch_TC2.sh: loc_root_annot: "$loc_root_annot
#echo "debug launch_TC2.sh: loc_comp_annot: "$loc_comp_annot

head -20 $loc_root_annot > root.t_annot
head -20 $loc_comp_annot > comp.t_annot

#run theme_compare with local copies
python3 theme_compare9.py $loc_r_tc $loc_c_tc 

#note:theme_compare calls comparison_heatmap2.R


#now clean up
#rm *.out
#rm *.matrix
#rm *.t_annot

