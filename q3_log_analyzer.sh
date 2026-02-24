#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: ./log_analyzer.sh <logfile>"
    exit 1
fi

log_file=$1

if [ ! -f "$log_file" ]; then
    echo "File not found."
    exit 1
fi

echo "========== LOG FILE ANALYSIS =========="
echo "File: $log_file"
echo ""

total_lines=$(wc -l < "$log_file")
echo "Total Entries: $total_lines"
echo ""

echo "Unique IP Addresses:"
awk '{print $1}' "$log_file" | sort -u
echo ""

echo "Status Code Summary:"
awk '{print $NF}' "$log_file" | sort | uniq -c
echo ""

echo "Top 3 IP Addresses:"
awk '{print $1}' "$log_file" | sort | uniq -c | sort -nr | head -3
