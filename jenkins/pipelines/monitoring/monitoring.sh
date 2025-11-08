#!/bin/sh
# Script pentru monitorizarea resurselor sistemului, compatibil cu Alpine Linux (/bin/sh)

# Creează folderul pentru log dacă nu există
mkdir -p /data

# Setare interval în secunde (default 5s)
INTERVAL=${INTERVAL:-5}

# Calea către fișierul de log în volumul montat
LOG_FILE="/data/system-state.log"

while true; do
    {
        echo "Date & Time: $(date '+%Y-%m-%d %H:%M:%S')"
        echo "Hostname: $(hostname)"
        echo "----------------------------------------------"
        
        echo "Memory Usage:"
        free | awk 'NR==1 || NR==2 {print}'
        echo "----------------------------------------------"
        
        echo "CPU Info:"
        echo "Load average (1/5/15 min): $(uptime | awk -F'load average:' '{print $2}')"
        echo "Top 3 CPU-consuming processes:"
        ps -eo pid,comm,%cpu,%mem --sort=-%cpu | head -n 4
        echo "----------------------------------------------"
        
        echo "Disk Usage:"
        df -h --total | grep -E "Filesystem|total"
        echo "----------------------------------------------"
        
        echo "Active Processes: $(ps -e --no-headers | wc -l)"
        echo "----------------------------------------------"
        
        echo "Network Interfaces:"
        ip -brief addr show | awk '{print $1, $3}'
        echo "=============================================="
    } > "$LOG_FILE"

    echo "System state updated in $LOG_FILE (interval: ${INTERVAL}s)"
    sleep "$INTERVAL"
done

