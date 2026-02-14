# Project title: Log Monitoring and Cleanup Script 

# 1. Project Overview

This project is a Bash automation script designed to manage log files efficiently

The script:
* Finds log files older than 7 days
* Moves them to an archive directory
* Compresses them into a .tar.gz archive
* Deletes archive files older than 30 days


# 2. Problem Statement
Log files grow continously over time and can consume significant disk space. And without proper cleanup, this may lead to:
* Storage exhaustion 
* Reduced system performance
* Operational issue

Manual cleanup is prone to errors and inefficient. This makes automation necessary. 


# 3. Solution Approach
To solve this problem, the script:

* 1. Uses the `find` command with `-type f` and `-mtime` to identify log files older than 7 days.
* 2. Moves the log files to an archive directory using `-exec mv`
* 3. Created a compressed archive using `tar -czf`
* 4. Deletes archives files olde than 30 days.
* 5. Provides summary of the script process at the end. 


# 4. Script Breakdown

`#!/bin/bash` <--- # This tells the Linux kernel to use Bash intepreter to execute the script. 

#### A. Created my variables
The first I did was to make use of variable to represent my paths rather than hard-coding it. This action gave me the flexibility for easy updates/changes during the development;if the directory changes, only the variable needs to be updated instead of modifying multiple lines. 

#Directories  
`LOG_DIR="$HOME/bash-project/log_project/logs" `  
`ARCHIVE_DIR="$HOME/bash-project/log_project/archive" `  
`LOG_PROJECT_DIR="$HOME/bash-project/log_project"`  

#### B. I created my Policy and counters variables. 

`#Policy`  
`ARCHIVE_RETENTION_DAYS=30 `  
`DAYS_OLD=7`  

`#Counters `  
`MOVED_COUNT=0`  
`ARCHIVED_COUNT=0`  
`DELETED_COUNT=0`  

* `DAYS_OLD` defines how old logs must be before archiving.
* `ARCHIVE_RETENTION_DAYS` defines how long archives are kept.
* Counters help track script operations. 


#### C. I used the find command with -type f and -mtime combined with -exec mv commannd to find and move log files.

find "$LOG_DIR" -type f -mtime +"$DAYS_OLD" -exec mv {} "$ARCHIVE_DIR" \; 

* `find` searches files in the `"$LOG_DIR"` directory. 
* `-type f` ensures only files are matched. 
* `-mtime +7`  finds files older than 7 days. 
* `-exec mv {} "$ARCHIVE_DIR"` takes the output of the find command and execute the move command on it, therby moving the files into the "$ARCHIVE_DIR". 

#### D. Creating the archive 
#Archive logs  
`TODAY=$(date +%F)`  
`ARCHIVE_FILE="logs_$TODAY.tar.gz"`  


#### E. Created an archive for the log files and compress it.

`tar -czf "$LOG_PROJECT_DIR/$ARCHIVE_FILE" -C "$ARCHIVE_DIR" .`  

`tar -czf` looks into the "$ARCHIVE_DIR" folder, creates an archive file, compressed all the log files found in the "$ARCHIVE_DIR", then saved it in the "$LOG_PROJECT_DIR". 

#### F. Check if the code run was successful and then remove the all log files from the archive directory.

`if [ $? -eq 0 ]; then
        ARCHIVED_COUNT=1 
        rm -f "$ARCHIVE_DIR"/*.log
fi`

The for loop above take the exit code of the script and check if it is succesful, then it goes ahead to increase the archived count and remove log files from the archive directory. 

`$?` is a special variable that stores the exit status of the last command.

#### G. Delete old archives that are passed 30 days. And update the deleted count. 

`find "$LOG_PROJECT_DIR" -type f name "logs_*.tar.gz" -mtime +"$ARCHIVE_RETENTIION_DAYS"  -exec rm -f {} \;`

The script line above looks for files that are in the form of "logs_*.tar.gz that are passed the "ARCHIVE_RETENTION_DAYS" in the Log project directory then execute the rm command on those files. 

#### H. Final Summary Output 

echo "Log Cleanup Summary"
echo "-------------------"
echo "Log directory: $LOG_DIR"
echo "Archive directory: $ARCHIVE_DIR"
echo "Archive created: $ARCHIVE_FILE"
echo "Old archives older than $ARCHIVE_RETENTION_DAYS days removed"
echo "Completed on: $(date)"


# 5. How to Run
To run the script, we first need to grant the script execute permission using:
`chmod +x log_cleanup.sh`
then, we run it:
`./log_cleanup.sh`


# 6. Automation with Cron
Now to automate the scritpt so that the system can perform this log cleanup process without thsystem admin running it manually everytime, we make use of the cronjobs to automate the running of the script.

*  open the crontab with `crontab -e`
* paste this at the end ` 0 8 * * * /path/to/the/script >> /path/to/the/log`

The Cronjob automate the scripts so that it runs at 8AM daily and append to a log file. 



# 7. Sample Output

Log Cleanup Summary  
-------------------  
Log directory: /home/olamide/bash-project/log_project/logs  
Archive directory: /home/olamide/bash-project/log_project/archive  
Archive created: logs_2026-02-13.tar.gz  
Old archives older than 30 days removed  
Completed on: Fri Feb 13 20:24:52 WAT 2026  


# 8. Lessons Learned
The major lessonds learned  
* How `tar -czf ` work for archiving & compressing.
* How to chain command effectively
* The importance of using variables instead of hard-coded paths.
* How to assign command output to variables.
* How exit code (`$?`) are used to verify command success.  

# 9. Future Improvements
- Add email alerts before deleting old archives
- Improve error handling.











