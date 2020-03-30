## insights-rds-db-dump-container
Container and scripts to dump/restore a database

Scripts to dump catalog & approval from production, they all use the container defined in `container_spec/`

-----

Pretty self-explanatory, but examples:

#### To dump: 

One would run `./catalog/dump_catalog_db.rb`, and that would place a postgresql dump titled `catalog_production_xxxx.sql.gz` in the current directory which is a gzipped `pg_dump` of the entire database. 

#### To restore: 

One would run `./catalog/restore_catalog_db.rb catalog_production_xxxx.sql.gz` which runs a container to restore, uploads the dump, and then overwrites the current data with the restore. 

#### Demo!

A video is worth 1000 words. 
[![asciicast](https://asciinema.org/a/VDFxGbtaoLZsoye7Sib6p6JD9.svg)](https://asciinema.org/a/VDFxGbtaoLZsoye7Sib6p6JD9)
