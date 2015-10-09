# Merge Property Files
Bash file that can merge two property files together

## Property Files
Property files are files that contain property names and their values. Such as:
```
com.property.one=value_one
com.property.two=value_two
...
```
## Master and Slave property files
It is possible that properties with the same name exist in both files. When this occurs the Master value will be preserved.

Example
Input:
```
// Master
com.property.one=master_value_one
com.property.two=master_value_two
// Slave
com.property.one=slave_value_two
com.property.three=slave_value_three
```
Output:
```
com.property.one=master_value_one
com.property.two=master_value_two // <-- Master value used, not slave
com.property.three=slave_value_three
```
## Usage
Simply update the following lines as required:
```
MASTER_FILE="./master.properties"
SLAVE_FILE="./slave.properties"
OUTPUT_FILE="./output.properties"
```
