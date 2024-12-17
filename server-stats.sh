#!/bin/bash

# Script: server-stats.sh
# Description: Basic server performance stats - CPU, Memory, Disk Usage, Top Processes, and more.
# Usage: Run the script on any Linux server. No arguments required.

echo "==========================================="
echo "        SERVER PERFORMANCE STATS           "
echo "==========================================="

# Function: Total CPU Usage
echo -e "\n1. Total CPU Usage:"
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8 "% used"}')
echo "   CPU Usage: $CPU_USAGE"

# Function: Total Memory Usage
echo -e "\n2. Total Memory Usage:"
MEMORY=$(free -m)
TOTAL_MEM=$(echo "$MEMORY" | grep Mem | awk '{print $2}')
USED_MEM=$(echo "$MEMORY" | grep Mem | awk '{print $3}')
FREE_MEM=$(echo "$MEMORY" | grep Mem | awk '{print $4}')
MEM_PERC=$(awk "BEGIN {printf \"%.2f\", ($USED_MEM/$TOTAL_MEM)*100}")
echo "   Total Memory: ${TOTAL_MEM}MB"
echo "   Used Memory: ${USED_MEM}MB (${MEM_PERC}%)"
echo "   Free Memory: ${FREE_MEM}MB"

# Function: Total Disk Usage
echo -e "\n3. Total Disk Usage:"
DISK=$(df -h / | grep /)
TOTAL_DISK=$(echo "$DISK" | awk '{print $2}')
USED_DISK=$(echo "$DISK" | awk '{print $3}')
FREE_DISK=$(echo "$DISK" | awk '{print $4}')
DISK_PERC=$(echo "$DISK" | awk '{print $5}')
echo "   Total Disk: $TOTAL_DISK"
echo "   Used Disk: $USED_DISK ($DISK_PERC)"
echo "   Free Disk: $FREE_DISK"

# Function: Top 5 Processes by CPU Usage
echo -e "\n4. Top 5 Processes by CPU Usage:"
ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6 | awk 'NR==1{print "   PID   COMMAND   %CPU"} NR>1{printf "   %-6s %-8s %s\n", $1, $2, $3}'

# Function: Top 5 Processes by Memory Usage
echo -e "\n5. Top 5 Processes by Memory Usage:"
ps -eo pid,comm,%mem --sort=-%mem | head -n 6 | awk 'NR==1{print "   PID   COMMAND   %MEM"} NR>1{printf "   %-6s %-8s %s\n", $1, $2, $3}'

# Stretch Goal: OS Version, Uptime, Load Average, and Logged-in Users
echo -e "\n6. Additional System Information:"
OS_VERSION=$(cat /etc/os-release | grep PRETTY_NAME | cut -d= -f2 | tr -d '"')
UPTIME=$(uptime -p)
LOAD_AVG=$(cat /proc/loadavg | awk '{print $1, $2, $3}')
LOGGED_USERS=$(who | wc -l)

echo "   OS Version: $OS_VERSION"
echo "   Uptime: $UPTIME"
echo "   Load Average (1, 5, 15 mins): $LOAD_AVG"
echo "   Logged-in Users: $LOGGED_USERS"

# Stretch Goal: Failed Login Attempts
echo -e "\n7. Failed Login Attempts:"
FAILED_LOGINS=$(grep "Failed password" /var/log/auth.log | wc -l)
echo "   Total Failed Logins: $FAILED_LOGINS"

echo "==========================================="
echo "          END OF PERFORMANCE STATS         "
echo "==========================================="
