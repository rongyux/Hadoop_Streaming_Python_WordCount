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
 
