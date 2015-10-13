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
    MASTER_PROPERTY_NAME=`echo $MASTER_FILE_LINE | cut -d = -f1`
    MASTER_PROPERTY_VALUE=`echo $MASTER_FILE_LINE | cut -d = -f2-`
    
    ALL_PROPERTIES[$MASTER_PROPERTY_NAME]=$MASTER_PROPERTY_VALUE
done

# Properties that are in the slave but not the master will be preserved
for SLAVE_FILE_LINE in "${SLAVE_FILE[@]}"; do
    SLAVE_PROPERTY_NAME=`echo $SLAVE_FILE_LINE | cut -d = -f1`
    SLAVE_PROPERTY_VALUE=`echo $SLAVE_FILE_LINE | cut -d = -f2-`
    
    # If a slave property exists in the master, the master's value will be used preserved
    if [ ! ${ALL_PROPERTIES[$SLAVE_PROPERTY_NAME]+_} ]; 
    then 
        ALL_PROPERTIES[$SLAVE_PROPERTY_NAME]=$SLAVE_PROPERTY_VALUE;
    fi
done

for KEY in "${!ALL_PROPERTIES[@]}"; do 
    echo "$KEY=${ALL_PROPERTIES[$KEY]}" >> "$OUTPUT_FILE"
done