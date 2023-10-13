

#!/bin/bash



# Define variables

DB_NAME=${DATABASE_NAME}

TABLE_NAME=${TABLE_NAME}

FILE_PATH=${FILE_PATH}



# Check file encoding

FILE_ENCODING=$(file -b --mime-encoding $FILE_PATH)

if [[ $FILE_ENCODING != "utf-8" ]]; then

  echo "ERROR: File encoding is not utf-8"

  exit 1

fi



# Check file formatting

pgfutter --db $DB_NAME --table $TABLE_NAME $FILE_PATH

if [[ $? -ne 0 ]]; then

  echo "ERROR: Failed to import data"

  exit 1

fi



echo "SUCCESS: Data imported successfully"

exit 0