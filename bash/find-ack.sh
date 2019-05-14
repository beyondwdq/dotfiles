#!/usr/bin/env bash
pattern=$1
dir=$2
filepattern=$3
ack -g "$filepattern" $dir | ack -x "$pattern"
