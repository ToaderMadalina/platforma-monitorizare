# Dockerfile pentru imaginea scriptului de backup Python.

FROM python:3.11-slim

# Copiem scriptul Python
COPY scripts/backup.py /usr/local/bin/backup.py

WORKDIR /data
RUN mkdir -p backup

CMD ["python3", "/usr/local/bin/backup.py"]

