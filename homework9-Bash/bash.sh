#!/bin/bash
TIME_START=$(date)
### definition path log file
if [ ! -z $1 ] 
then
    if [ ! -e $1 ]
    then
    echo "not found the file log" 
    exit 1
    else
       FILE_NAME=$1 
    fi    
else
    $(find /var/log/nginx/ -type f -name 'access.log' &>/dev/null)
    if [ $? -ne 0 ]
    then 
        echo "need to specify the log file"
        exit 1
    else
        FILE_NAME="/var/log/nginx/access.log"
    fi    
fi    
### create file with last timestamp
if [ ! -e "/last_timestamp" ]
then
    echo 0 > /last_timestamp
fi


### block support function
function get_last_timestamp {
   TIME_STAMP=$(grep -E '^([0-9]+\.*){4}(\s-?){3}\[.*\]' ${FILE_NAME} \
   |  tail -n 1 | cut -d ' ' -f 4  \
   |sed -e 's/\[//g' -e 's/\//-/g' \
   | awk -F':' '{print $1,$2":"$3":"$4}' )
   
    date +%s -d "${TIME_STAMP}"

}

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

### check installation mutt
$(mutt -v &>/dev/null)

if [  $? -ne 0 ] 
then
    echo "Error: mutt not installed"
    exit 1
fi
### two temporary variables, since functions cannot be compared
TMP=$(get_last_timestamp)
TMS=$(cat /last_timestamp)

### main block, sand email
if [ "${TMP}" -gt "${TMS}" ]  
then

mutt -s "parse log" -- root@localhost << EOF 
Data for the period:${TIME_START}-$(date)
URL:
$(get_http_request)

IP:
$(get_ip)

Error code:
$(get_error_code)
EOF

echo $TMP > /last_timestamp
fi

### add task in crontab
grep -i 'flock -w0 /var/lock /bash.sh' /etc/crontab &>>/dev/null

if [ $? -ne 0 ]
then
    cat '* * * * * root flock -w0 /var/lock /bash.sh'  >> /etc/crontab
fi
