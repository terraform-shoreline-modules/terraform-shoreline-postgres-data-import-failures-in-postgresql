

#!/bin/bash



# Get the filename and target PostgreSQL database name as arguments

filename=${FILENAME}

database=${DATABASE_NAME}



# Check if the file exists

if [ ! -f $filename ]; then

    echo "File $filename not found!"

    exit 1

fi



# Check if PostgreSQL is running

if ! pg_isready -q; then

    echo "PostgreSQL is not running!"

    exit 1

fi



# Fix the data format

sed -i 's/\r//' $filename



# Import the data into PostgreSQL

psql -d $database -c "COPY ${TABLE_NAME} FROM '$filename' DELIMITER ',' CSV HEADER;"