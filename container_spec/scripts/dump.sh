#!/usr/bin/env sh

export PGPASSWORD=$DATABASE_PASSWORD 
export DUMP_NAME=/tmp/${DATABASE_NAME}-$(date +%s).sql.gz

pg_dump \
    --host $DATABASE_HOST \
    --dbname $DATABASE_NAME \
    --username $DATABASE_USER \
    | gzip > $DUMP_NAME

echo "Ding! Your dump is ready at: $DUMP_NAME"

# Now sit and wait while we copy the appropriate files out.
exec tail -f /dev/null
