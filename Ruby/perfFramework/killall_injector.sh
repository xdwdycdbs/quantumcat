#!/bin/bash


mPath=./perf_agent/
toPath=/home/ycai/lightweight-perf/perf_agent/
fileName=$1


for ((i=1;i<=9;i=i+1))
do
        ssh injector0$i
        sudo killall ruby
        exit
done

ssh injector10
sudo killall ruby
exit

ssh injector11
sudo killall ruby
exit
