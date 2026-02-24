#!/bin/bash

while true
do
    echo ""
    echo "====== FILE & DIRECTORY MANAGER ======"
    echo "1. List files"
    echo "2. Create directory"
    echo "3. Create file"
    echo "4. Delete file"
    echo "5. Rename file"
    echo "6. Search file"
    echo "7. Count files & folders"
    echo "8. Exit"
    echo "======================================="

    read -p "Enter your choice: " option

    case $option in

    1)
        ls -lh
        ;;

    2)
        read -p "Enter new directory name: " dir_name
        mkdir "$dir_name"
        echo "Directory created."
        ;;

    3)
        read -p "Enter new file name: " file_name
        touch "$file_name"
        echo "File created."
        ;;

    4)
        read -p "Enter file name to delete: " file_name
        if [ -f "$file_name" ]; then
            rm "$file_name"
            echo "File deleted."
        else
            echo "File not found."
        fi
        ;;

    5)
        read -p "Enter current file name: " old_name
        read -p "Enter new file name: " new_name
        if [ -f "$old_name" ]; then
            mv "$old_name" "$new_name"
            echo "File renamed."
        else
            echo "File not found."
        fi
        ;;

    6)
        read -p "Enter file name to search: " pattern
        find . -name "$pattern"
        ;;

    7)
        file_count=$(find . -type f | wc -l)
        dir_count=$(find . -type d | wc -l)
        echo "Total Files      : $file_count"
        echo "Total Directories: $dir_count"
        ;;

    8)
        echo "Exiting..."
        break
        ;;

    *)
        echo "Invalid choice."
        ;;
    esac

done
