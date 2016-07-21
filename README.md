The function of the sample program is to static the words count of a big log file in the pattern of mapreduce.
The program is composed with three files, two py files and one bash file.
If you have a hadoop environment with linux system, you can output bash -x setup.sh to run the program.
And there will be 3 output files in the directory.
The file named map.py is a file to map the content of input log into words and the file named reduce.py is the file to wort out the counts of words in tasker.

本人博客：http://www.cnblogs.com/rongyux/p/5621494.html

这是搭建hadoop环境后的第一个MapReduce程序；

　　基于hadoop streaming的python的脚本；

 

　　1 map.py文件，把文本的内容划分成单词：
复制代码

#!/usr/bin/python
import sys

for line in sys.stdin:
    line = line.strip()
    words = filter(lambda word: word, line.split())
    for word in words:
        print('%s\t%s' % (word, 1))

复制代码

　　

　　2 reduce文件，把统计单词出现的次数；
复制代码

import sys
from operator import itemgetter

wc_dict = {}
for line in sys.stdin:
    line = line.strip()
    word, count = line.split()
    try:
        count = int(count)
        wc_dict[word] = wc_dict.get(word, 0) + count
    except ValueError:
        pass

sorted_dict = sorted(wc_dict.items(), key=itemgetter(0))
for word, count in sorted_dict:
    print '%s\t%s' % (word, count)
        

复制代码

 

　　3 Hadoop调用脚本：指定输出目录OUTPUT；

　　调用支持多语言的streaming的编程环境，参数-input是输入的log文件，为了用mapreduce模式统计这个文件每个单词出现的次数；-output是输出路径；-mapper是mapper编译 此处是python语言；-reducer是reduce编译语法；-file是mapper文件路径和reduce文件路径；-numReduceTaskers 是使用的子tasker数目，这里是3，代表分成了3了tasker分布式的处理计数任务；
复制代码

#!/bin/bash

OUTPUT=/home/apm3/outdir
hadoop fs -rmr $OUTPUT
hadoop jar /usr/local/hadoop/share/hadoop/tools/lib/hadoop-streaming-2.7.2.jar \
-input /opt/mapr/logs/warden.log \
-output $OUTPUT \
-mapper "python map.py" \
-reducer "python reduce.py" \
-file map.py \
-file reduce.py \
-numReduceTasks 3  
 

复制代码

 

　　bash -x start.sh 会在输出路径中生成三个输出文件，及三分ReduceTasks 输出的结果；（MapReduce 模式主要做了shuffle和sort任务，shuffle是按照hashkey分配单词到子tasker中，而sort是排序的功能。）

 　　4 MapR里执行程序，run.sh:
复制代码

hadoop fs -rm -r /user/rongyu/

hadoop jar hadoop-streaming-2.7.0-mapr-1602.jar \
-input /user/input/* \
-output /user/rongyu/output \
-mapper word_count_mapper.py \
-reducer word_count_reducer.py \
-file *.py \
-numReduceTasks 3

复制代码

　　5 查看结果

 

　　查看输出目录： 命令 $ hadoop fs -ls /user/rongyu/output/

Found 4 items
-rwxr-xr-x   3 mapr mapr          0 2016-07-05 01:14 /user/rongyu/output/_SUCCESS
-rwxr-xr-x   3 mapr mapr    1835563 2016-07-05 01:14 /user/rongyu/output/part-00000
-rwxr-xr-x   3 mapr mapr    1827557 2016-07-05 01:14 /user/rongyu/output/part-00001
-rwxr-xr-x   3 mapr mapr    1840519 2016-07-05 01:14 /user/rongyu/output/part-00002

 

　　输出三个输出文件之一part-00000：命令 $ hadoop fs -cat /user/rongyu/output/part-00000 | less
复制代码

/nodes/apm1/services/nfs        17
/opt/mapr/conf/cldb.conf        12
/opt/mapr/hostid        6
/services/cldb/master.  4
/services/fileserver.   2
/services/fileserver/master     1
/services/hbmaster/apm2.        1
/services/hbregionserver/apm4.  207
/services/hbregionserver/master 1
/services/historyserver/master  1
/services/hoststats/apm2.       2
/services/kvstore/apm3. 2
/services/nfs.  22
/services/nfs/master.   53
/services_config/kvstore.       2
/services_config/nodemanager.   3
/services_config/nodemanager/apm4.      26
00:00:00,3402   1
00:00:00,4710   1
00:00:01,6710   1
00:00:01,7916   1
00:00:01,9725   1

复制代码
