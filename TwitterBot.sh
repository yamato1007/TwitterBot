#!bin/bash

log="log.txt"

cd `dirname $0`

date +"%c" >> $log
stack exec TwitterBot >> $log 2>&1
