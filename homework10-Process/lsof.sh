#!/bin/bash
#find  /proc/ -type d  -maxdepth 1 |grep -Eo '[0-9]+'
 for x in `ps -eF| awk '{ print $2 }'`; \
 do echo `ls /proc/$x/fd 2> /dev/null | \
 wc -l` $x `cat /proc/$x/cmdline 2> /dev/null`; \
 done | sort -n -r | head -n 20