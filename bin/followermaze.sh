#! /bin/bash

SEED=666
EVENTS=1500
CONCURRENCY=150

time java -server -XX:-UseConcMarkSweepGC -Xmx2G -jar ./bin/FollowerMaze-assembly-1.0.jar $SEED $EVENTS $CONCURRENCY
