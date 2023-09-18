grep -E '^([0-9]+\.*){4}' access-4560-644067.log | cut -d' ' -f1 |  uniq -c |sort -bgr | head -n 10

grep -E '^([0-9]+\.*){4}[\s|-]*\[.*]\s".+"\s\w{3}\s' access-4560-644067.log