FROM alpine:latest

WORKDIR /app

# Copiem scriptul în container
COPY scripts/monitoring.sh /app/monitoring.sh

RUN chmod +x /app/monitoring.sh

CMD ["/app/monitoring.sh"]

