#!/bin/bash

echo "=============================="
echo "        USER REPORT"
echo "=============================="
echo ""

# ================= USER STATISTICS =================

echo "=== USER STATISTICS ==="

total_users=$(wc -l < /etc/passwd)
system_users=$(awk -F: '$3 < 1000 {count++} END {print count+0}' /etc/passwd)
regular_users=$(awk -F: '$3 >= 1000 {count++} END {print count+0}' /etc/passwd)
current_logged=$(who | awk '{print $1}' | sort -u | wc -l)

echo "Total Users: $total_users"
echo "System Users (UID < 1000): $system_users"
echo "Regular Users (UID >= 1000): $regular_users"
echo "Currently Logged In: $current_logged"
echo ""

# ================= USER DETAILS =================

echo "=== REGULAR USER DETAILS ==="

printf "%-12s %-6s %-20s %-15s %-20s\n" "Username" "UID" "Home Directory" "Shell" "Last Login"
printf "%-12s %-6s %-20s %-15s %-20s\n" "--------" "---" "--------------" "-----" "----------"

awk -F: '$3 >= 1000 {print $1 ":" $3 ":" $6 ":" $7}' /etc/passwd | while IFS=: read user uid home shell
do
    last_login=$(lastlog -u "$user" | awk 'NR==2 {print $4,$5,$6,$7,$8}')
    
    if [ -z "$last_login" ]; then
        last_login="Never logged in"
    fi
    
    printf "%-12s %-6s %-20s %-15s %-20s\n" "$user" "$uid" "$home" "$shell" "$last_login"
done

echo ""

# ================= GROUP INFORMATION =================

echo "=== GROUP INFORMATION ==="

printf "%-20s %-10s\n" "Group Name" "Members"
printf "%-20s %-10s\n" "----------" "-------"

awk -F: '{ 
    if ($4 == "") 
        count=0; 
    else 
        count=split($4,a,","); 
    printf "%-20s %-10d\n", $1, count 
}' /etc/group

echo ""

# ================= SECURITY CHECK =================

echo "=== SECURITY ALERTS ==="

# Root users
root_users=$(awk -F: '$3 == 0 {print $1}' /etc/passwd)
root_count=$(awk -F: '$3 == 0 {count++} END {print count+0}' /etc/passwd)

echo "Users with root privileges (UID 0): $root_count"
echo " - $root_users"
echo ""

# Users without passwords (regular users only)
echo "Users without passwords (Regular Users Only):"

no_password_found=0

while IFS=: read -r username password uid rest
do
    if [ "$uid" -ge 1000 ]; then
        if [ "$password" = "!" ] || [ "$password" = "*" ]; then
            echo "$username"
            no_password_found=1
        fi
    fi
done < /etc/shadow

if [ "$no_password_found" -eq 0 ]; then
    echo "All regular users have passwords set"
fi

echo ""

# Inactive users (never logged in)
echo "Inactive Users (Never Logged In):"

inactive_found=0

awk -F: '$3 >= 1000 {print $1}' /etc/passwd | while read user
do
    last_login=$(lastlog -u "$user" | awk 'NR==2 {print $0}')
    
    if echo "$last_login" | grep -q "Never logged in"; then
        echo "$user"
        inactive_found=1
    fi
done

echo ""
echo "=============================="
echo "        END OF REPORT"
echo "=============================="
