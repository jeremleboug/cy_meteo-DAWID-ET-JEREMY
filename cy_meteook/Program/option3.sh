#!/bin/bash
#t3/p3

rm -f "$2" # makes sure the touched file doesn't exist 

./main -f $1 -o "../temp_sorted/$4.csv" $5 # sorts the file

awk -F ';' '{t=$1; $1 = $2; $2 = t; print}' OFS=';' "../temp_sorted/$4.csv" > ../temp/temptorp3.csv #switches the first and second column 
./main

./main -f ../temp/temptorp3.csv -o "../temp_sorted/$4.csv" $5 # sorts the file

input_file="../temp_sorted/$4.csv" # variable used for input
output_file="$2" # variable used for output
valeur="$3" # variable used to determin which column is important
touch "$output_file" # opening to write in output
count='0' # count variable
tempvariable1='' # variables used to stock specific values
tempvariable2='' # variables used to stock specific values
tempvariable3='' # variables used to stock specific values
notfirst='0'

# Loop through each line of the input file
while read -r L || [[ -n "$L" ]]; 
do
    # checks it's the first line or not
    if [ "$notfirst" -ne '0' ];
    then
        # for loop that goes through all the caracters in a line
        for (( i=0; i<${#L}; i++ )); 
        do
            if [ "${L:$i:1}" = ";" ]; 
            then
                count=$((count+1))
            elif [ "$count" -eq "0" ];
            then
                tempvariable1=$tempvariable1${L:$i:1}
            elif [ "$count" = "1" ];
            then
                tempvariable2=$tempvariable2${L:$i:1}
            elif [ "$count" = "$valeur" ];
            then
                tempvariable3=$tempvariable3${L:$i:1}
            fi
        done
        # determins if variables should be used
        if [ ! "$tempvariable3" = '' ];
        then
            echo "$tempvariable2;$tempvariable1;$tempvariable3" >> "$output_file"
            tempvariable1=''
            tempvariable2=''
            tempvariable3=''
        fi
    else
        notfirst='1'
        #determins which variable to use
        if [ "$3" = "p3" ];
        then
            echo "Date;ID OMM station;Pressure" >> "$output_file"
        elif [ "$3" = "t3" ];
        then
            echo "Date;ID OMM station;Temperature" >> "$output_file"
        fi
    fi
    count='0'
done < "$input_file"   

exec 3<&- #closes files
exec 4<&- #closes files

rm -f ../temp/temptorp3.csv #delets for stability

