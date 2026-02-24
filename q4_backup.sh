#!/bin/bash

echo "====== BACKUP SCRIPT ======"

read -p "Enter directory to backup: " source_dir
read -p "Enter backup destination: " backup_dir

if [ ! -d "$source_dir" ]; then
    echo "Source directory does not exist."
    exit 1
fi

mkdir -p "$backup_dir"

timestamp=$(date +%Y%m%d_%H%M%S)

echo "1. Simple Copy"
echo "2. Compressed Backup (tar.gz)"
read -p "Choose backup type: " choice

start_time=$(date +%s)

if [ "$choice" = "1" ]; then
    cp -r "$source_dir" "$backup_dir/backup_$timestamp"
    backup_file="$backup_dir/backup_$timestamp"
else
    backup_file="$backup_dir/backup_$timestamp.tar.gz"
    tar -czf "$backup_file" "$source_dir"
fi

end_time=$(date +%s)
time_taken=$((end_time - start_time))

echo "Backup completed successfully."
echo "Location: $backup_file"
du -sh "$backup_file"
echo "Time Taken: $time_taken seconds"
