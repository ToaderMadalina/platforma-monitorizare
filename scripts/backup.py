# Script Python pentru efectuarea backup-ului logurilor de sistem.

#!/usr/bin/env python3
import os
import time
import shutil
from datetime import datetime

# Variabile de mediu cu valori implicite
INTERVAL = int(os.getenv("BACKUP_INTERVAL", 5))
BACKUP_DIR = os.getenv("BACKUP_DIR", "backup")
SOURCE_FILE = "system-state.log"

# Creăm directorul de backup dacă nu există
os.makedirs(BACKUP_DIR, exist_ok=True)

print(f"[INFO] Backup monitor started. Interval: {INTERVAL}s, Backup dir: {BACKUP_DIR}")

# Ultima modificare pentru a detecta schimbări
last_mtime = None

try:
    while True:
        if os.path.exists(SOURCE_FILE):
            current_mtime = os.path.getmtime(SOURCE_FILE)

            if current_mtime != last_mtime:
                timestamp = datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
                backup_name = f"system-state_{timestamp}.log"
                backup_path = os.path.join(BACKUP_DIR, backup_name)

                try:
                    shutil.copy2(SOURCE_FILE, backup_path)
                    print(f"[INFO] Backup created: {backup_path}")
                    last_mtime = current_mtime
                except Exception as e:
                    print(f"[ERROR] Failed to create backup: {e}")
            else:
                print("[INFO] No changes detected.")
        else:
            print(f"[WARN] Source file '{SOURCE_FILE}' not found.")

        time.sleep(INTERVAL)

except KeyboardInterrupt:
    print("\n[INFO] Backup monitor stopped by user.")
except Exception as e:
    print(f"[ERROR] Unexpected error: {e}")

