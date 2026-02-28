---
name: live-monitor
description: Poll a log file for new lines while a named process is running, exiting automatically when the process terminates.
---

# Live-monitor a background process

Poll a log file for new lines while a named process is running, then exit
once the process is gone.

```bash
log_file="/var/log/messages"
p_name="firefox"

tail -n10 $log_file
curr_line="$(tail -n1 $log_file)"
last_line="$(tail -n1 $log_file)"

while [ $(ps aux | grep $p_name | grep -v grep | wc -l) -gt 0 ] 
do
        curr_line="$(tail -n1 $log_file)"
        if [ "$curr_line" != "$last_line" ]
        then
                echo $curr_line
                last_line=$curr_line
        fi  
done
echo "[*] $p_name exited !!"
```
