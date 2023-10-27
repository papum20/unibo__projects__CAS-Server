#!/bin/bash

docker ps --format "table {{.Names}}\t{{.Image}}\t{{.RunningFor}}\t{{.Status}}\t{{.Size}}\t{{.Ports}}" | (head -n 1 && awk 'NR>1{print "\n" $0}' && echo)
