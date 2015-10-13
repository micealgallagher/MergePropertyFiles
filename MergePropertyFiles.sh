#!/bin/bash
MASTER_FILE="./master.properties"
SLAVE_FILE="./slave.properties"
OUTPUT_FILE="./output.properties"

# Delete the output file
rm -rf "$OUTPUT_FILE"

readarray MASTER_FILE < "$MASTER_FILE"
readarray SLAVE_FILE < "$SLAVE_FILE"

declare -A ALL_PROPERTIES

# All the master file property names and values will be preserved
for MASTER_FILE_LINE in "${MASTER_FILE[@]}"; do
    IFS='=' read -r MASTER_PROPERTY_AND_VALUE <<< "$MASTER_FILE_LINE"

    MASTER_PROPERTY_NAME="${MASTER_PROPERTY_AND_VALUE[0]}"
    MASTER_PROPERTY_VALUE="${MASTER_PROPERTY_AND_VALUE[1]}"
    
    ALL_PROPERTIES[$MASTER_PROPERTY_NAME]=$MASTER_PROPERTY_VALUE
done

# Properties that are in the slave but not the master will be preserved
for SLAVE_FILE_LINE in "${SLAVE_FILE[@]}"; do
    IFS='=' read -r SLAVE_PROPERTY_AND_VALUE <<< "$SLAVE_FILE_LINE"

    SLAVE_PROPERTY_NAME="${SLAVE_PROPERTY_AND_VALUE[0]}"
    SLAVE_PROPERTY_VALUE="${SLAVE_PROPERTY_AND_VALUE[1]}"
    
    # If a slave property exists in the master, the master's value will be used preserved
    if [ ! ${ALL_PROPERTIES[$SLAVE_PROPERTY_NAME]+_} ]; 
    then 
        ALL_PROPERTIES[$SLAVE_PROPERTY_NAME]=$SLAVE_PROPERTY_VALUE;
    fi
done

for KEY in "${!ALL_PROPERTIES[@]}"; do 
    echo "$KEY=${ALL_PROPERTIES[$KEY]}" >> "$OUTPUT_FILE"
done