#!/bin/bash

LOGFILE="$HOME/backup_logs/log.txt"

full_backup(){

        echo "Full backup başlatılıyor..."
        TIMESTAMP=$(date "+%Y-%m-%d-%H-%M-%S")
        REMOTE_DIR="full-backup-server/full_${TIMESTAMP}/"
        ssh -i ~/.ssh/id_rsa <hedef_username>@<hedef_ip> "mkdir -p ${REMOTE_DIR}"
        rsync -avzP --delete -e "ssh -i ~/.ssh/id_rsa" backup/ <hedef_username>@<hedef_ip>:${REMOTE_DIR}
        if [ $? -eq 0 ]; then
            echo "$TIMESTAMP: Full backup başarıyla tamamlandı." >> $LOGFILE
        else
            echo "$TIMESTAMP: Full backup HATA!" >> $LOGFILE
        fi
        echo "Full backup tamamlandı."
}

incremental_backup(){

        echo "Incremental backup başlatılıyor..."
        TIMESTAMP=$(date "+%Y-%m-%d-%H-%M-%S")
        LATEST_FULL_BACKUP=$(ssh -i ~/.ssh/id_rsa <hedef_username>@<hedef_ip> 'ls -t $HOME/full-backup-server/full_* | head -1')
        REMOTE_DIR="backup-server/inc_${TIMESTAMP}/"
        ssh -i ~/.ssh/id_rsa <hedef_username>@<hedef_ip> "mkdir -p ${REMOTE_DIR}"
        rsync -avzP --link-dest="${LATEST_FULL_BACKUP}" -e "ssh -i ~/.ssh/id_rsa" backup/ <hedef_username>@<hedef_ip>:${REMOTE_DIR}
        if [ $? -eq 0 ]; then
            echo "$TIMESTAMP: Incremental backup başarıyla tamamlandı." >> $LOGFILE
        else
            echo "$TIMESTAMP: Incremental backup HATA!" >> $LOGFILE
        fi
        echo "Incremental backup tamamlandı."
}

case "$1" in
        full) full_backup;;
        inc) incremental_backup;;
        *) echo "Yanlış girdi"
        exit 1
        ;;
esac

exit 0
