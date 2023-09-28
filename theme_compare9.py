#!/usr/bin/python3

#2022.02.26
#chad storer
#compbio theme overlap comparison code

import sys
import os
import subprocess
import getopt
import pandas as pd
import numpy as np

#usage
#   python3 theme_compare9.py <full_path_to_root_Theme_Coordinates.js> <full_path_to_compare_Theme_Coordinates.js>

#theme files are expected to be in following format
#Theme1  val1    Theme2  val2    Theme3  val3
#bill    1       apple   1       tiger   1
#tom     1       pear    1       dog     1
#fred    1       grape   1       cat     1
#john    1       mango   1       duck    1

#get files from arguments:
open_rootdf=pd.read_csv(sys.argv[1], sep="\t")
open_compdf=pd.read_csv(sys.argv[2], sep="\t")


#create output matrix name:
root=sys.argv[1]
comp=sys.argv[2]
base_root=os.path.splitext(root)[0]
base_comp=os.path.splitext(comp)[0]
#remove "_Theme_Coordinates" from the names
short_base_root = base_root.replace("_Theme_Coordinates", "")
short_base_comp = base_comp.replace("_Theme_Coordinates", "")
outfile=short_base_root+"_vs_"+short_base_comp+".matrix"

#------------------DATA FRAME CREATION------------------------------------------
#process themes.txt input data to just contain concepts
#drop every other column in both dataframes, as those contain the scores
#start with open_rootdf
drop_rootdf = list(range(1, open_rootdf.shape[1],2))                                 #debugprint(drop_rootdf)
drop_rootcols = [j for i,j in enumerate(open_rootdf.columns) if i in drop_rootdf]    #debug#print(drop_rootcols)
rootdf = open_rootdf.drop(drop_rootcols, axis=1)                                     #debug#print(rootdf.head())
#rootdf.columns = rootdf.columns.str.replace("Theme=", "Root=")                       #debug#print(rootdf.head())
rootdf.columns = rootdf.columns.str.replace("Theme=", "")                       #debug#print(rootdf.head())

#now open_compdf
drop_compdf = list(range(1, open_compdf.shape[1],2))                                 #debug#print(drop_compdf)
drop_compcols = [j for i,j in enumerate(open_compdf.columns) if i in drop_compdf]    #debug#print(drop_compcols)
compdf = open_compdf.drop(drop_compcols, axis=1)                                     #debug#print(compdf.head())  
#compdf.columns = compdf.columns.str.replace("Theme=", "Comp=")                       #debug#print(compdf.head())
compdf.columns = compdf.columns.str.replace("Theme=", "")                       #debug#print(compdf.head())

#remove "Concept=", and "Gene=" from rootdf and compdf
rootdf = rootdf.replace('Concept=', '', regex=True)
rootdf = rootdf.replace('Gene=', '', regex=True)                                     #debug#print(rootdf.head())

compdf = compdf.replace('Concept=', '', regex=True)
compdf = compdf.replace('Gene=', '', regex=True)                                     #debug#print(compdf.head())

#now concatenate into one df
#finaldf = rootdf.append(compdf, sort=False)                                          #debug#print(finaldf)
finaldf = pd.concat([rootdf, compdf], axis=1)

#------------------------Make array of arrays for 

#convert df columns to list
#rt1 = rootdf['Root=1'].tolist()
#cp1 = compdf['Comp=1'].tolist()
#list(set(rt1) & set(cp1))
#can just do it directly:
#r1_vs_c1 = list(set(rootdf['1']) & set(compdf['1']))
#r2_vs_c2 = list(set(rootdf['1']) & set(compdf['2']))

#so I need an array of rt arrays that keep track of the overlap against all cp columns
#get columns
root_col = len(rootdf.columns)
root_row = len(rootdf)
comp_col = len(compdf.columns)
comp_row = len(compdf)

#r1_v_c3 = len (list(set(rootdf['Theme1']) & set(compdf['Theme3'])))

#can be rewritten as below using indexes vs title names
#r1_v_c3 = len (list(set(rootdf.iloc[:,0]) & set(compdf.iloc[:,2])))


ol_dat = pd.DataFrame(np.zeros((comp_col, root_col))) #initialize overlap dataframe

for x in range(0, root_col):
    for y in range(0, comp_col):
        overlap = len (list(set(rootdf.iloc[:, x]) & set(compdf.iloc[:, y])))
        ol_dat.iloc[y, x] = overlap

ol_dat.to_csv(outfile)

cmd = "Rscript comparison_heatmap.R "+outfile 


subprocess.call(cmd, shell=True)

