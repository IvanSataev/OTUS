#!/bin/bash
if [ -z $1 ] 
then
    echo "need to transfer the file log" 
    exit 1
elif [ ! -e $1 ]
then
    echo "not found the file log" 
    exit 1
fi  

FILE_NAME=$1

FILE_NAME=access-4560-644067.log
function get_ip() {
grep -E '^([0-9]+\.*){4}' ${FILE_NAME} | cut -d' ' -f1 | sort | uniq -c |sort -bgr | awk '{ print "Number of request: " $1, "IP: "$2 }'
}
function get_http_request {
grep -E '^([0-9]+\.*){4}(\s-?){3}\[.*\]\s"(GET|HEAD|POST).+"\s\w{3}\s' ${FILE_NAME} | cut -d '"' -f 2 | cut -d ' ' -f 2| sort | uniq -c |sort -bgr
}

function get_error_code {
grep -E '^([0-9]+\.*){4}(\s-?){3}\[.*\]\s"(GET|HEAD|POST).+"\s\w{3}\s' ${FILE_NAME} | cut -d '"' -f 3 | cut -d ' ' -f 2| sort | uniq -c |sort -bgr
}

if [ ! -N ${FILE_NAME} ]  
then
get_ip
fi
 
