# Folosim Alpine ca imagine de bază
FROM alpine:latest

# Instalăm utilitare necesare
RUN apk add --no-cache bash procps iproute2 coreutils

# Setăm directorul de lucru
WORKDIR /app

# Copiem scriptul în container
COPY monitoring.sh /app/monitoring.sh

# Facem scriptul executabil
RUN chmod +x /app/monitoring.sh

# Scriptul va scrie log în /data (volume mapat)
VOLUME ["/data"]

# Comanda default la rulare
CMD ["/bin/sh", "/app/monitoring.sh"]

