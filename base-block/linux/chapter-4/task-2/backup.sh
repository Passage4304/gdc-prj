#!/bin/bash

SOURCE_DIR=/home/artem/git/hub/gdc-prj/base-block/linux/chapter-4/task-2/very-important-dir
LOCAL_BACKUP_DIR=/home/artem/git/hub/gdc-prj/base-block/linux/chapter-4/task-2/local-backup-of-very-important-dir
DESTINATION_BACKUP_DIR=/mnt/data-hard-1TB/Backups/learning/very-important-dir

DATA_FORMAT=%d-%m-%Y_%H-%M-%S
CURRENT_DATETIME=$(date +$DATA_FORMAT)

INCREMENT_BACKUP_FILE_NAME=backup-$(date +$DATA_FORMAT).tar.gz

mkdir -p $LOCAL_BACKUP_DIR

if [ ! -f $LOCAL_BACKUP_DIR/backup-initial.tar.gz ]; then
    tar -czvg $LOCAL_BACKUP_DIR/snapshot-file -f $LOCAL_BACKUP_DIR/backup-initial.tar.gz --absolute-names $SOURCE_DIR
    cp $LOCAL_BACKUP_DIR/backup-initial.tar.gz $DESTINATION_BACKUP_DIR

    md5sum $LOCAL_BACKUP_DIR/backup-initial.tar.gz | awk {'print $1'} > $LOCAL_BACKUP_DIR/backup-initial.tar.gz.md5
    sed -i '1 s/$/ \/mnt\/data-hard-1TB\/Backups\/learning\/very-important-dir\/backup-initial.tar.gz' $LOCAL_BACKUP_DIR/backup-initial.tar.gz.md5
    md5sum -c $LOCAL_BACKUP_DIR/$LOCAL_BACKUP_DIR/backup-initial.tar.gz.md5

    if [ $? -eq 0 ]; then
        rm $LOCAL_BACKUP_DIR/$LOCAL_BACKUP_DIR/backup-initial.tar.gz.md5
        echo -e "Initial backup created successfully\n" >> /home/artem/learning/scripts/logs/backup/backup-log
        echo -e "Date and time of backup: $CURRENT_DATETIME" >> /home/artem/learning/scripts/logs/backup/backup-log
        echo -e "-----------------------------------------------" >> /home/artem/learning/scripts/logs/backup/backup-log
    else 
        echo -e "ERROR | Backup crashed!" >&2
    fi
else 
    tar -czvg $LOCAL_BACKUP_DIR/snapshot-file -f $LOCAL_BACKUP_DIR/$INCREMENT_BACKUP_FILE_NAME --absolute-names $SOURCE_DIR
    cp $LOCAL_BACKUP_DIR/$INCREMENT_BACKUP_FILE_NAME $DESTINATION_BACKUP_DIR

    md5sum $LOCAL_BACKUP_DIR/$INCREMENT_BACKUP_FILE_NAME | awk {'print $1'} > $LOCAL_BACKUP_DIR/$INCREMENT_BACKUP_FILE_NAME.md5
    sed -i '1 s/$/ \/mnt\/data-hard-1TB\/Backups\/learning\/very-important-dir\/'"$INCREMENT_BACKUP_FILE_NAME"'/' $LOCAL_BACKUP_DIR/$INCREMENT_BACKUP_FILE_NAME.md5
    md5sum -c $LOCAL_BACKUP_DIR/$INCREMENT_BACKUP_FILE_NAME.md5

    if [ $? -eq 0 ]; then
        rm $LOCAL_BACKUP_DIR/$INCREMENT_BACKUP_FILE_NAME.md5
        echo -e "Increment backup created successfully\n" >> /home/artem/learning/scripts/logs/backup/backup-log
        echo -e "Date and time of backup: $CURRENT_DATETIME" >> /home/artem/learning/scripts/logs/backup/backup-log
        echo -e "-----------------------------------------------" >> /home/artem/learning/scripts/logs/backup/backup-log
    else 
        echo -e "ERROR | Backup crashed!" >&2
    fi
fi