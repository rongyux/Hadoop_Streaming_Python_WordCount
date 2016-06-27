The function of the sample program is to static the words count of a big log file in the pattern of mapreduce.
The program is composed with three files, two py files and one bash file.
If you have a hadoop environment with linux system, you can output bash -x setup.sh to run the program.
And there will be 3 output files in the directory.
The file named map.py is a file to map the content of input log into words and the file named reduce.py is the file to wort out the counts of words in tasker.
