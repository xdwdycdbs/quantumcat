#!/bin/bash

fromPath=./perf_agent/
toPath=/home/ycai/lightweight-perf/perf_agent/
fileName=$1


for ((i=1;i<=9;i=i+1))
do
	scp  $fromPath/$fileName injector0$i:$toPath
done
scp  $fromPath/$fileName injector10:$toPath
