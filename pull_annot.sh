#!/usr/bin/bash
#2022.02.25
#chad storer
#script to pull autoannotaion from *_Auto_Annotation.txt and 
#append them to ouptput from format_matrix.sh (*_Theme_Coordinates.csv.out)

#Usage:
#   sh pull_annot.sh <full_path_to_Auto_Annotation.txt>


#*_Auto_Annotation.txt has the following format
#Project
#        Chemokines (T-cell chemotaxis)  29.334397
#        ADORA2B mediated anti-inflammatory cytokines production 26.213463
#        NF-kappaB p50/p65 complex       22.221975
#    
#Theme 1
#        Rig-I Irf/Antiviral Response     4.6
#        Pathogen-associated myd88-dependent Toll-like receptor-5 signaling       2.8
#Theme 2
#Theme 3
#        Beta-TrCP ubiquitinates NFKB p50:p65:phospho IKBA complex        4.7
#        RUNX1 and FOXP3 control the development of regulatory T lymphocytes (Tregs)      3.9

#get file from arguments:
ANNOT=$1

#get base name without extension
annot_base="$(basename "${ANNOT}" .txt )"
#get dir
annot_dir="$(dirname "${ANNOT}")"
#make local output file
#annot_out="$annot_dir""/""$annot_base"".t_annot"
annot_out="$annot_base"".t_annot"
#echo $ANNOT
#echo $annot_base
#echo $annot_dir
#echo $annot_out

#remove header until Theme 1
sed -n '/^Theme 1$/, $p' $ANNOT > annot.temp
#make one big ugly line
#black magic and voodoo ensues...
cat annot.temp | 
	sed 's/\t//g' 			| 
	tr '\n' ' ' 			| 
	sed 's/Theme /\nTheme /g' 	| 
	sed 's/ [0-9]\+\.[0-9].*//' 	| 
	sed 's/Theme /Theme_/' 		| 
	sed 's/ /\t/' 			|
	sed 's/Theme_.*\t$/&&/' 	| 
	sed '/^$/d' 			|
        cut -f2				|	
	sed 's/\t$//' | cut -c 1-30 > $annot_out

rm *.temp

