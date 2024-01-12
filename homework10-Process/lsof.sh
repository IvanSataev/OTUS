#!/bin/bash
format="%-10s %-20s %-30s %15s\n" 

printf "$format" PID USER NAME COMM

 for proc in `ps -eF | awk '{ print $2 }'`

 do 
    test="/proc/$proc"
   if [[ -d "$test" ]]
    then
    user=`awk '/Uid/{print $2}' /proc/$proc/status`
    comm=`cat /proc/$proc/comm`
    if [[ user -eq 0 ]]
     then
       user_name='root'
     else
       #user_name=`grep $user /etc/passwd | awk -F ":" '{print $1}'`
       user_name=`id $user | awk '{print $1}' | awk -F "(" '{print $2}' | awk -F ")" '{print $1}'`
       echo $user_name
    fi
    map_files=`readlink /proc/$proc/map_files/*; readlink /proc/$proc/cwd`
    if ! [[ -z "$map_files" ]]
    then
    for num in $map_files
    do
    printf "$format" $proc $user_name $num $comm
    done
    fi
   fi 
 done 

 