# Project title: Log Monitoring and Cleanup Script 

# Project Overview

This project is a Bash automation script designed to manage log files efficiently

The script:
* Finds log files older than 7 days
* Moves them to an archive directory
* Compresses them into a .tar.gz archive
* Deletes archive files older than 30 days


# Problem Statement
Log files grow continously over time and can consume significant disk space. And without proper cleanup, this may lead to:
* Storage exhaustion 
* Reduced system performance
* Operational issue

Manual cleanup is prone to errors and inefficient. This makes automation necessary. 


# Solution Approach

I used find command with -type f and -mtime command to find log files that are older than 7 days in a specified project directory. Then I used -exec mv command to move the log files into another folder called archive. 


# Script Breakdown

#!/bin/bash <--- # This tells the Linux kernel which intepreter to used to run the script

#### A. Created my variables
The first I did was to make use of variable to represent my paths rather than hard-coding it. This action gave me the flexibility for easy updates/changes during the development; when a pat is hard-coded and there is need for change, you will need to find every instance in which you have used the path, but with the use of variables, you just need to update the it and the changes will be applied to every intance in which you have used the path in the script. 

#Directories \  
`LOG_DIR="$HOME/bash-project/log_project/logs" \ 
ARCHIVE_DIR="$HOME/bash-project/log_project/archive" \ 
LOG_PROJECT_DIR="$HOME/bash-project/log_project"`  \

B. I created my Policy and counters variables. 

`#Policy
ARCHIVE_RETENTION_DAYS=30 
DAYS_OLD=7`

`#Counters 
MOVED_COUNT=0
ARCHIVED_COUNT=0
DELETED_COUNT=0`


C. I used the find command with -type f and -mtime combined with -exec mv commannd to find and move log files.

find "$LOG_DIR" -type f -mtime +"$DAYS_OLD" -exec mv {} "$ARCHIVE_DIR" \; 

find --> Used the find command to find files in the "$LOG_DIR" directory. 
-type f ---> used to specify the type what you are looking for, either files(f) or directory(d) (In this case we are looking for files)
-mtime + ---> used to specify the date range in which the find command will for. In this case, we are looking for files that are older than the specified day. 
-exec mv {} ---> takes the output of the find command and execute the move command on it, therby moving the files into the "$ARCHIVE_DIR". 

D. Create archive logs 
#Archive logs 
TODAY=$(date +%F)
ARCHIVE_FILE="logs_$TODAY.tar.gz"


E. Created an archive for the log files and compress it.

tar -czf "$LOG_PROJECT_DIR/$ARCHIVE_FILE" -C "$ARCHIVE_DIR" .  

tar -czf ---> looks into the "$ARCHIVE_DIR" folder, creates an archive file, compressed all the log files found in the "$ARCHIVE_DIR", then saved it in the "$LOG_PROJECT_DIR". 

F. Check if the code run was successful and then remove the all log files from the archive directory.

if [ $? -eq 0 ]; then
        ARCHIVED_COUNT=1 
        rm -f "$ARCHIVE_DIR"/*.log
fi

The for loop above take the exit code of the script and check if it is succesful, then it goes ahead to increase the archived count and remove log files from the archive directory. 

$? is a special variable that represent the exit code of a bash script. 

G. Delete old archives that are passed 30 days. And update the deleted count. 

find "$LOG_PROJECT_DIR" -type f name "logs_*.tar.gz" -mtime +"$ARCHIVE_RETENTIION_DAYS"  -exec rm -f {} \;

The script line above looks for files that are in the form of "logs_*.tar.gz that are passed the "ARCHIVE_RETENTION_DAYS" in the Log project directory then execute the rm command on those files. 

H. Added some messages to the end of the scripts to clone real world performance

echo "Log Cleanup Summary"
echo "-------------------"
echo "Log directory: $LOG_DIR"
echo "Archive directory: $ARCHIVE_DIR"
echo "Archive created: $ARCHIVE_FILE"
echo "Old archives older than $ARCHIVE_RETENTION_DAYS days removed"
echo "Completed on: $(date)"


6. How to Run
To run the script, we first need to grant the script execute permission using:
chmod +x log_cleanup.sh
then, we run it:
./log_cleanup.sh


7. Automation with Cron
Now to automate the scritpt so that the system can perform this log cleanup process without thsystem admin running it manually everytime, we make use of the cronjobs to automate the running of the script.

  i. open the crontab with "crontab -e"
  ii. 0 8 * * * /path/to/the/script >> /path/to/the/log

The Cronjob automate the scripts so that it runs at 8AM daily and save/append the results to the log file in the specified directory.  



8. Sample Output

Log Cleanup Summary
-------------------
Log directory: /home/olamide/bash-project/log_project/logs
Archive directory: /home/olamide/bash-project/log_project/archive
Archive created: logs_2026-02-13.tar.gz
Old archives older than 30 days removed
Completed on: Fri Feb 13 20:24:52 WAT 2026


9. Lessons Learned
The major command i use was the tar -czf, it was the command that create the archive file and compress it. I learned how to chained commands in bash and I see the benefits of using variables instead of hard-coded paths.
Picked few lessons on hwo to assign the result of command to variables. 


11. Future Improvements
Possible future improvements is to make the script to send alert out before cleaning up the old archive files. 












