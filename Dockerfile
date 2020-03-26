FROM postgres:10-alpine

COPY scripts/dump.sh /bin/dump.sh
COPY scripts/restore.sh /bin/restore.sh
ENTRYPOINT ["dump.sh"]
