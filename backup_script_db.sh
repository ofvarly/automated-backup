#!/bin/bash

LOGFILE="$HOME/backup_logs/log.txt"
DB_NAME="employees"
DB_USER="root"
BACKUP_DIR="backup-db"

full_backup_db(){
        echo "Full DB backup başlatılıyor..."
        TIMESTAMP=$(date "+%Y-%m-%d-%H-%M-%S")
        DUMP_FILE="$HOME/dumps/employees_${TIMESTAMP}.sql"

        sudo mysqldump -u $DB_USER -p'1234' $DB_NAME > $DUMP_FILE
        if [ $? -ne 0 ]; then
            echo "$TIMESTAMP: MySQL dump HATA!" >> $LOGFILE
            echo "MySQL dump alınırken hata oluştu."
            return 1
        fi

        REMOTE_DIR="~/full-backup-server-db/"
        ssh -i ~/.ssh/id_rsa <hedef_username>@<hedef_ip> "mkdir -p ${REMOTE_DIR}"
        rsync -avzP --delete -e "ssh -i ~/.ssh/id_rsa" $DUMP_FILE <hedef_username>@<hedef_ip>:${REMOTE_DIR}full_${TIMESTAMP}
        if [ $? -eq 0 ]; then
            echo "$TIMESTAMP: Full DB backup başarıyla tamamlandı." >> $LOGFILE
        else
            echo "$TIMESTAMP: Full DB backup HATA!" >> $LOGFILE
        fi
        echo "Full DB backup tamamlandı."
}

incremental_backup_db(){
        echo "Incremental DB backup başlatılıyor..."
        TIMESTAMP=$(date "+%Y-%m-%d-%H-%M-%S")
        DUMP_FILE="$HOME/dumps/employees_${TIMESTAMP}.sql"

        sudo mysqldump -u $DB_USER -p'1234' $DB_NAME > $DUMP_FILE
        if [ $? -ne 0 ]; then
            echo "$TIMESTAMP: MySQL dump HATA!" >> $LOGFILE
            echo "MySQL dump alınırken hata oluştu."
            return 1
        fi

        LATEST_FULL_BACKUP_DB=$(ssh -i ~/.ssh/id_rsa <hedef_username>@<hedef_ip> 'ls -t $HOME/full-backup-server-db/full_* | head -1')
        REMOTE_DIR="~/inc-backup-server-db/"
        ssh -i ~/.ssh/id_rsa <hedef_username>@<hedef_ip> "mkdir -p ${REMOTE_DIR}"
        rsync -avzP --link-dest="${LATEST_FULL_BACKUP}" -e "ssh -i ~/.ssh/id_rsa" $DUMP_FILE <hedef_username>@<hedef_ip>:${REMOTE_DIR}
        if [ $? -eq 0 ]; then
            echo "$TIMESTAMP: Incremental DB backup başarıyla tamamlandı." >> $LOGFILE
        else
            echo "$TIMESTAMP: Incremental DB backup HATA!" >> $LOGFILE
        fi
        echo "Incremental DB backup tamamlandı."
}


case "$1" in
        full) full_backup_db;;
        inc) incremental_backup_db;;
        *) echo "Yanlış girdi"
        exit 1
        ;;
esac

exit 0

