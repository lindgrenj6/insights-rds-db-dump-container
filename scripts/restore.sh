#!/usr/bin/env sh

export PGPASSWORD=$DATABASE_PASSWORD 
export DUMP_NAME=$1

gunzip -c $DUMP_NAME | psql --host $DATABASE_HOST \
                            --dbname $DATABASE_NAME \
                            --username $DATABASE_USER

echo "Ding! Your database has been restored."
