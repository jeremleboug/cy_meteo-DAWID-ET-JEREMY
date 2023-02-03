#!/bin/bash
#t2/p2

rm -f "$2" # makes sure the touched file doesn't exist 

#determins which columns to switch
if [ "$4" = "0" ];
then
    awk -F ';' '{t=$1; $1 = $6; $6 = t; print}' OFS=';' $1 > ../temp/temptorp4.csv #switches the first and second column 
elif [ "$4" = "1" ];
then
    awk -F ';' '{t=$1; $1 = $14; $14 = t; print}' OFS=';' $1 > ../temp/temptorp4.csv #switches the first and second column 
fi

###############
./main -f $1 -o "../temp_sorted/$5.csv" -r $6 # sorts the file
############### if main.c doesn't work coment those lines and uncoment the one called spacial case

input_file="../temp_sorted/$5.csv" # variable used for input  #special case# comment this line
#special case# input_file=../temp/temptorp4.csv  #or a sorted file 
output_file="$2" # variable used for output
touch "$output_file"  # opening to write in output 
count='0' # count variable
tempvariable1='' # variables used to stock specific values
tempvariable2='' # variables used to stock specific values
tempvariable3='' # variables used to stock specific values
temphalt='0'
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
            # puts caracters in certan variable
            if [ "${L:$i:1}" = ";" ]; 
            then
                count=$((count+1))
            elif [ "$count" -eq "0" ];
            then
                tempvariable1=$tempvariable1${L:$i:1}
            elif [ "$count" = "9" ];
            then
                if [ "${L:$i:1}" = "," ];
                then
                    temphalt='1'
                elif [ "$temphalt" = '0' ];
                then
                    tempvariable2=$tempvariable2${L:$i:1}
                elif [ "$temphalt" = '1' ];
                then
                    tempvariable3=$tempvariable3${L:$i:1}
                fi
            fi
        done
        # determins if variables should be used
        if [ ! "$tempvariable1" = '' ];
        then
            echo "$tempvariable1;$tempvariable3;$tempvariable2" >> "$output_file"
            tempvariable1=''
            tempvariable2=''
            tempvariable3=''
        fi
    else
        notfirst='1'
        echo "$3;Longitude : X;Latitude : Y" >> "$output_file"
    fi
    count='0'
    temphalt='0'
done < "$input_file"   

exec 3<&- #closes files
exec 4<&- #closes files

rm -f ../temp/temptorp4.csv #delets for stability