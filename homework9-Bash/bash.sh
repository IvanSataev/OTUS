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
TIME_STAMP=$(date)

function get_ip { 
grep -E '^([0-9]+\.*){4}' ${FILE_NAME} \
| cut -d ' ' -f1 \
| sort \
| uniq -c \
| sort -bgr \
| awk '{ print "Number of request: " $1, "IP: " $2 }' | head -n 10
}

function get_http_request {
grep -E '^([0-9]+\.*){4}(\s-?){3}\[.*\]\s"(GET|HEAD|POST).+"\s\w{3}\s' ${FILE_NAME} \
| cut -d '"' -f 2 \
| cut -d ' ' -f 2 \
| sort | uniq -c \
|sort -bgr \
| awk '{ print "Number of request: " $1, "URL: " $2 }' | head -n 10
}

function get_error_code {
grep -E '^([0-9]+\.*){4}(\s-?){3}\[.*\]\s"(GET|HEAD|POST).+"\s\w{3}\s' ${FILE_NAME} \
| cut -d '"' -f 3 | cut -d ' ' -f 2 \
| sort | uniq -c |sort -bgr \
| awk '{ print "Number of request: " $1, "CODE: " $2 }'
}

$(mutt -v &>/dev/null)

if [  $? -ne 0 ] 
then
    echo "Error: mutt not installed"
    exit 1
fi

if [ ! -N ${FILE_NAME} ]  
then


mutt -s "subject" -- sataev.i@samberi.com << EOF 
Data for the period:$TIME_STAMP
URL:
$(get_http_request)

IP:
$(get_ip)

Error code:
$(get_error_code)
EOF
fi
#* * * * * root flock -w0 /tmp/1.lock /bash.sh 