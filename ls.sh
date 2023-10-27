#!/bin/bash

docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Size}}\t{{.Ports}}" | (head -n 1 && awk 'NR>1{print $0}' | sort && echo)
