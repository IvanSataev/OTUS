grep -E '^([0-9]+\.*){4}' access-4560-644067.log | cut -d' ' -f1 |  uniq -c |sort -bgr | head -n 10

grep -E '^([0-9]+\.*){4}\s|-*\[.*\]\s"[GET|HEAD|POST].+"\s\w{3}\s' access-4560-644067.log | awk '{print $1 $2 $3 $4}'

grep -E '^([0-9]+\.*){4}\s|-*\[.*\]\s"[GET|HEAD|POST].+"\s\w{3}\s' access-4560-644067.log | awk '{print $7}' | uniq -c |sort -bgr