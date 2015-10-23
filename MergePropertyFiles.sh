#!/bin/bash
MASTER_FILE="$1"
SLAVE_FILE="$2"
OUTPUT_FILE="$3"

# Delete the output file
rm -rf "$OUTPUT_FILE"


# Ensure files exist before attempting to merge
if [ ! -e $MASTER_FILE ] ; then
    echo 'Unable to merge property files: MASTER_FILE doesn''t exist'
    exit
fi

if [ ! -e $SLAVE_FILE ] ; then
    echo 'Unable to merge property files: SLAVE_FILE doesn''t exist'
    exit
fi

# Read property files into arrays
readarray MASTER_FILE < "$MASTER_FILE"
readarray SLAVE_FILE < "$SLAVE_FILE"

# Regex strings to check for values and 
COMMENT_LINE_REGEX="[#*]"
HAS_VALUE_REGEX="[*=*]"

declare -A ALL_PROPERTIES

# All the master file property names and values will be preserved
for MASTER_FILE_LINE in "${MASTER_FILE[@]}"; do

    MASTER_PROPERTY_NAME=`echo $MASTER_FILE_LINE | cut -d = -f1`

    # Only attempt to get the property value if it exists
    if [[ $MASTER_FILE_LINE =~ $HAS_VALUE_REGEX ]]
    then
        MASTER_PROPERTY_VALUE=`echo $MASTER_FILE_LINE | cut -d = -f2-`
    else
        MASTER_PROPERTY_VALUE=''
    fi
    
    # Ignore the line if it begins with the # symbol as it is a comment
    if ! [[ $MASTER_PROPERTY_NAME =~ $COMMENT_LINE_REGEX ]]
    then
        ALL_PROPERTIES[$MASTER_PROPERTY_NAME]=$MASTER_PROPERTY_VALUE
    fi
done

# Properties that are in the slave but not the master will be preserved
for SLAVE_FILE_LINE in "${SLAVE_FILE[@]}"; do
    SLAVE_PROPERTY_NAME=`echo $SLAVE_FILE_LINE | cut -d = -f1`
    SLAVE_PROPERTY_VALUE=`echo $SLAVE_FILE_LINE | cut -d = -f2-`
    
    # Only attempt to get the property value if it exists
    if [[ $MASTER_FILE_LINE =~ $HAS_VALUE_REGEX ]]
    then
        MASTER_PROPERTY_VALUE=`echo $MASTER_FILE_LINE | cut -d = -f2-`
    else
        MASTER_PROPERTY_VALUE=''
    fi

    # If a slave property exists in the master, the master's value will be used preserved
    if [ ! ${ALL_PROPERTIES[$SLAVE_PROPERTY_NAME]+_ } ]; 
    then
        # If the line begins with a # symbol it is a comment line and should be ignored
        if ! [[ $SLAVE_PROPERTY_NAME =~ $COMMENT_LINE_REGEX ]]
        then
            ALL_PROPERTIES[$SLAVE_PROPERTY_NAME]=$SLAVE_PROPERTY_VALUE
        fi
    fi
done

for KEY in "${!ALL_PROPERTIES[@]}"; do
    echo "$KEY=${ALL_PROPERTIES[$KEY]}" >> "$OUTPUT_FILE"
done
