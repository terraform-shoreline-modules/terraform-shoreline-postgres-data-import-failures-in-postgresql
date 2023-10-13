pg_dump ${DATABASE_NAME} > dump.sql

pg_restore --list dump.sql