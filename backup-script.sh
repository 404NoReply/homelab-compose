#!/bin/bash
backupDate=$(date +'%F')
WEBHOOK_URL="DISCORD_WEBHOOK_URL"

# --- STOP CONTAINERS ---
cd /home/username/docker-applications/beszel && docker compose stop > /dev/null 2>&1
cd /home/username/docker-applications/code-server && docker compose stop > /dev/null 2>&1
cd /home/username/docker-applications/forgejo && docker compose stop > /dev/null 2>&1
cd /home/username/docker-applications/wordpress && docker compose stop > /dev/null 2>&1

# --- CREATE BACKUP ---
cd /home/username
tar -czf ./backup-$backupDate.tar.gz ./docker-applications

# --- START CONTAINERS ---
cd /home/username/docker-applications/beszel && docker compose start > /dev/null 2>&1
cd /home/username/docker-applications/code-server && docker compose start > /dev/null 2>&1
cd /home/username/docker-applications/forgejo && docker compose start > /dev/null 2>&1
cd /home/username/docker-applications/wordpress && docker compose start > /dev/null 2>&1

# --- CLOUD SYNC & CLEANUP ---
cd /home/username
rclone --config "/home/username/.config/rclone/rclone.conf" copy backup-$backupDate.tar.gz remoteGoogleDrive:docker-backups
rclone --config "/home/username/.config/rclone/rclone.conf" delete remoteGoogleDrive:docker-backups --min-age 10d --drive-use-trash=false
rm backup-$backupDate.tar.gz

# --- DISCORD NOTIFICATION ---
curl -H "Content-Type: application/json" -X POST -d "{
  \"content\": \"**Backup to Google Drive Successful:** $backupDate\"
}" "$WEBHOOK_URL"