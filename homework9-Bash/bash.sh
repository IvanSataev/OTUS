### get ip
grep -E '^([0-9]+\.*){4}' access-4560-644067.log | cut -d' ' -f1 | sort | uniq -c |sort -bgr

### get http
grep -E '^([0-9]+\.*){4}(\s-?){3}\[.*\]\s"(GET|HEAD|POST).+"\s\w{3}\s' access-4560-644067.log | cut -d '"' -f 2 | cut -d ' ' -f 2| sort | uniq -c |sort -bgr
### get code
grep -E '^([0-9]+\.*){4}(\s-?){3}\[.*\]\s"(GET|HEAD|POST).+"\s\w{3}\s' access-4560-644067.log | cut -d '"' -f 3 | cut -d ' ' -f 2| sort | uniq -c |sort -bgr
