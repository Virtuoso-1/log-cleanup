

#!/bin/bash 

# Directories 
LOG_DIR="$HOME/bash-project/log_project/logs"
ARCHIVE_DIR="$HOME/bash-project/log_project/archive"
LOG_PROJECT_DIR="$HOME/bash-project/log_project"


# Policy
ARCHIVE_RETENTION_DAYS=30 
DAYS_OLD=7

# Counters 
MOVED_COUNT=0
ARCHIVED_COUNT=0
DELETED_COUNT=0


DELETED_COUNT=$(find "$LOG_PROJECT_DIR" -name "logs_*.tar.gz" -mtime +"$ARCHIVE_RETENTION_DAYS" | wc -l)

# Move and count moved files
find "$LOG_DIR" -type f -mtime +"$DAYS_OLD" -exec mv {} "$ARCHIVE_DIR" \; 
MOVED_COUNT=$(ls "$ARCHIVE_DIR"/*.log 2>/dev/null | wc -l)

# Archive logs 
TODAY=$(date +%F)
ARCHIVE_FILE="logs_$TODAY.tar.gz"


tar -czf "$LOG_PROJECT_DIR/$ARCHIVE_FILE" -C "$ARCHIVE_DIR" .  

if [ $? -eq 0 ]; then
	ARCHIVED_COUNT=1 
	rm -f "$ARCHIVE_DIR"/*.log
fi

# Delete old archives 
DELETED_COUNT=$(find "$LOG_PROJECT_DIR" -name "logs_*.tar.gz" -mtime +"$ARCHIVE_RETENTION_DAYS" | wc -l)

find "$LOG_PROJECT_DIR" -type f name "logs_*.tar.gz" -mtime +"$ARCHIVE_RETENTIION_DAYS"  -exec rm -f {} \; 


echo "Log Cleanup Summary"
echo "-------------------"
echo "Log directory: $LOG_DIR"
echo "Archive directory: $ARCHIVE_DIR"
echo "Archive created: $ARCHIVE_FILE"
echo "Old archives older than $ARCHIVE_RETENTION_DAYS days removed"
echo "Completed on: $(date)"

