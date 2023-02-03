#!/bin/bash
#t2/p2

rm -f "$2" # makes sure the touched file doesn't exist 

./main -f $1 -o "../temp_sorted/$3.csv" $4 # sorts the file

input_file="../temp_sorted/$3.csv" # variable used for input
output_file="$2" # variable used for output
touch "$output_file"  # opening to write in output 
count='0' # count variable
tempvariable1='' # variables used to stock specific values
tempvariable2='' # variables used to stock specific values
tempvariable3='' # variables used to stock specific values
tempvariable4='' # variables used to stock specific values
lat='' # lat def
long='' # long def
notfirst='0' 
nextvalue='0'
verifvalue='0'
change='1'  # variable used for better determination on first value
tempearray1=() # array used to hold variables
tempearray2=() # array used to hold variables
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
            elif [ "$count" = "2" ];
            then
                tempvariable2=$tempvariable2${L:$i:1}
            elif [ "$count" = "3" ];
            then
                tempvariable3=$tempvariable3${L:$i:1}
            elif [ "$count" = "9" ];
            then
                tempvariable4=$tempvariable4${L:$i:1}
            fi
        done
        # determins if variables should be used
        if [ "$firstvar" = '' ];
        then
            if [ ! "$tempvariable2" = '' ] && [ ! "$tempvariable3" = '' ];
            then
                if [ "$change" -eq '1' ];
                then
                    firstvar=$tempvariable1
                    change='0'
                fi
                coords=$tempvariable4
                tempearray1+=("$tempvariable2")
                tempearray2+=("$tempvariable3")
                firstvartemp=$tempvariable1
            fi  
        else
            if [ "$firstvar" -eq "$tempvariable1" ];
            then
                if [ ! "$tempvariable2" = '' ] && [ ! "$tempvariable3" = '' ];
                then
                    coords=$tempvariable4
                    tempearray1+=("$tempvariable2")
                    tempearray2+=("$tempvariable3")
                    firstvartemp=$tempvariable1
                    if [ "$change" -ne '1' ];
                    then
                        firstvar=$tempvariable1
                        change='0'
                    fi
                fi
            else
                if [ ! "$tempvariable2" = '' ] && [ ! "$tempvariable3" = '' ];
                then
                    temp=$((temp+1))
                    firstvar=$tempvariable1
                fi
            fi
            sum1='0'
            sum2='0'
            # calculates and then prints the values we want into output
            if [ ! "$tempvariable2" = '' ] && [ ! "$tempvariable3" = '' ];
            then
                if [ ! "$firstvar" = "$firstvartemp" ];
                then
                    change='1'
                    for i in "${tempearray1[@]}";
                    do
                        sum1=$(echo "$sum1 + $i" | bc)
                    done
                    for i in "${tempearray2[@]}";
                    do
                        sum2=$(echo "$sum2 + $i" | bc)
                    done
                    array_length1=${#tempearray1[@]}
                    array_length2=${#tempearray2[@]}
                    med1=$(echo "$sum1 / $array_length1" | bc -l)
                    med2=$(echo "$sum1 / $array_length2" | bc -l)
                    val='0'
                    for (( i=0; i<${#tempvariable4}; i++ )); 
                    do
                        if [ "${tempvariable4:$i:1}" = ',' ];
                        then
                            val='1'
                        elif [ "$val" = '0' ];
                        then
                            lat=$lat${tempvariable4:$i:1}
                        elif [ "$val" = '1' ];
                        then
                            long=$long${tempvariable4:$i:1}
                        fi
                    done
                    echo "$firstvartemp;$med1;$med2;$long;$lat" >> "$output_file"
                    tempearray1=("$tempvariable2")
                    tempearray2=("$tempvariable3")
                    tempvariable1=''
                    tempvariable2=''
                    tempvariable3=''
                    tempvariable4=''
                    long=''
                    lat=''   
                fi
            fi
        fi
        tempvariable1=''
        tempvariable2=''
        tempvariable3=''
        after=$tempvariable4
        tempvariable4=''
    else
        notfirst='1'
        echo "ID OMM station;MoyDirection;MoyVelocity;Longitude : X;Latitude : Y" >> "$output_file"
    fi
    count='0'
done < "$input_file"   

# calculates and then prints the values we want
for i in "${tempearray1[@]}";
do
    sum1=$(echo "$sum1 + $i" | bc)
done
for i in "${tempearray2[@]}";
do
    sum2=$(echo "$sum2 + $i" | bc)
done
array_length1=${#tempearray1[@]}
array_length2=${#tempearray2[@]}
med1=$(echo "$sum1 / $array_length1" | bc -l)
med2=$(echo "$sum1 / $array_length2" | bc -l)
val='0'
for (( i=0; i<${#after}; i++ )); 
do
    if [ "${after:$i:1}" = ',' ];
    then
        val='1'
    elif [ "$val" = '0' ];
    then
        lat=$lat${after:$i:1}
    elif [ "$val" = '1' ];
    then
        long=$long${after:$i:1}
    fi
done
echo "$firstvartemp;$med1;$med2;$long;$lat" >> "$output_file"
exec 3<&- #closes files
exec 4<&- #closes files