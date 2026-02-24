#!/bin/bash

echo "========================================"
echo "        SYSTEM INFORMATION REPORT       "
echo "========================================"

current_user=$(whoami)
host_name=$(hostname)
current_time=$(date "+%Y-%m-%d %H:%M:%S")
os_name=$(uname -s)
present_dir=$(pwd)
home_dir=$HOME
logged_users=$(who | wc -l)
system_uptime=$(uptime -p)

echo "Username         : $current_user"
echo "Hostname         : $host_name"
echo "Date & Time      : $current_time"
echo "Operating System : $os_name"
echo "Current Directory: $present_dir"
echo "Home Directory   : $home_dir"
echo "Users Logged In  : $logged_users"
echo "System Uptime    : $system_uptime"

echo "========================================"
