#!/usr/bin/python3
#2023.02.11
#chad storer

#removed the "var data =" from Theme_Coordinates.js
#remove final ; from Theme_Coordinates.js
#run this first
 
#need to get Theme_Coordinates.js file into python script like this:
#Theme1  val1    Theme2  val2    Theme3  val3
#bill    1       apple   1       tiger   1
#tom     1       pear    1       dog     1

import json
import pandas as pd
from pandas import json_normalize
import sys
import os

#remove "var data = " from first line
my_file = sys.argv[1]
cmd1 = "sed 's/var data = //' " + my_file +" > temp"
cmd2 = "sed -i 's/^];/]/' " + my_file +" temp"
#print("debug: final command1 will look like ", cmd1)
#print("debug: final command2 will look like ", cmd2)
os.system(cmd1)
os.system(cmd2)

#command argument loading
#my_file = sys.argv[1]
#with open(my_file, 'r') as f:
with open("temp", 'r') as f:
    json_data = json.load(f)

#write first 20 themes to file 
data = json_data[0:20]

#Turn into a dataframe
data_as_table = pd.DataFrame(data)

#now need make a short table with name and concepts
short_table = data_as_table[["Name", "Concepts"]]


base = os.path.splitext(my_file)[0]
outfile = base + ".csv"
short_table.to_csv(outfile)

os.remove("temp")

#now run format_matrix.sh
#then run theme_compare5.py

