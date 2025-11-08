# Dockerfile pentru imaginea scriptului de monitorizare bash.

FROM ubuntu:22.04

# Instalam utilitare de sistem necesare
RUN apt-get update && \
    apt-get install -y iproute2 procps && \
    rm -rf /var/lib/apt/lists/*

COPY scripts/monitoring.sh /usr/local/bin/monitoring.sh
RUN chmod +x /usr/local/bin/monitoring.sh

WORKDIR /data

CMD ["bash", "/usr/local/bin/monitoring.sh"]


