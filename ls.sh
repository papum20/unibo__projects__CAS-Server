#!/bin/bash

docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Size}}\t{{.Ports}}" | awk 'NR==1{print $0;next} {print $0 | "sort"}'
