#!/bin/python
import sys
word_dict = {}
for line in sys.stdin:
    v = line.strip()
    if word_dict.has_key(v):
        word_dict[v] += 1
    else:
        word_dict[v] = 1

for key in word_dict:
    print key + "\t" + str(word_dict[key])
        

