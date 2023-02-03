#!/bin/bash
#t2/p2

rm -f "$2" # makes sure the touched file doesn't exist 

awk -F ';' '{t=$1; $1 = $2; $2 = t; print}' OFS=';' $1 > ../temp/temptorp2.csv #switches the first and second column 

./main -f ../temp/temptorp2.csv -o "../temp_sorted/$4.csv" $5 # sorts the file

input_file="temptorp2.csv"  # variable used for input
output_file="$2" # variable used for output
valeur="$3"  # variable used to determin which column is important
touch "$output_file" # opening to write in output
count='0' # count variable
firstvar=''
tempvariable='' # variables used to stock specific values
tempvariable2='' # variables used to stock specific values
dateverif='0'
avrage='' # avrage def
notfirst='0'
temp='0'
tempearray=() # array used to hold variables
arraytemp='0'# verifs

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
            if [ "$count" -eq "0" ];
            then
                if [ ! ${L:$i:1} = ':' ] && [ "$dateverif" -eq '0' ];
                then
                    tempvariable=$tempvariable${L:$i:1}
                elif [ ${L:$i:1} = ':' ];
                then
                    dateverif='1'
                fi
            fi
            if [ "${L:$i:1}" = ";" ]; 
            then
                count=$((count+1))
            elif [ "$count" = "$valeur" ];
            then
                tempvariable2=$tempvariable2${L:$i:1}
            fi
        done
        # determins if variables should be used
        if [ "$firstvar" = '' ] && [ ! "$tempvariable2" = '' ];
        then
            firstvar=$tempvariable
            tempearray+=("$tempvariable2")
            tempvariable2=''
            firestvar2="$tempvariable"
        elif [ ! "$firstvar" = '' ] && [ ! "$tempvariable2" = '' ];
        then
            if [ "$firstvar" = "$tempvariable" ];
            then 
                tempearray+=("$tempvariable2")
                firestvar2="$tempvariable"
                tempvariable2=''
            else
                temp=$((temp+1))
                firstvar=$tempvariable
            fi
        fi
        sum='0'
        # calculates and then prints the values we want
        if [ "$temp" -ne "$arraytemp" ];
        then
            #echo " temp = $temp arrtemp = $arraytemp"   
            arraytemp=$((arraytemp+1))
            for i in "${tempearray[@]}";
            do
                sum=$(echo "$sum + $i" | bc)
            done
            array_length=${#tempearray[@]}".0"
            # echo "array = ${tempearray[@]}" # uncomment to check arrays
            echo "sum = $sum array length =$array_length"
            avrage=$(echo "$sum / $array_length" | bc -l)
            echo "$firestvar2;$avrage" >> "$output_file"
            tempearray=("$tempvariable2")
            tempvariable2=''
            sum=0
        fi
        tempvariable=''
        count='0'
    else
        notfirst='1'
        echo "Date;moy" >> "$output_file"
    fi
    dateverif='0'
done < "$input_file"   
arraytemp=$((arraytemp+1))
for i in "${tempearray[@]}";
do
    sum=$(echo "$sum + $i" | bc)
done
array_length=${#tempearray[@]}".0"
# echo "array = ${tempearray[@]}" #uncoment to check arrays
echo "sum = $sum array length =$array_length"
avrage=$(echo "$sum / $array_length" | bc -l)
echo "$firstvar;$avrage" >> "$output_file"
tempearray=("$tempvariable2")
tempvariable2=''
sum='0'
exec 3<&- #closes files
exec 4<&- #closes files

rm "-f ../temp/temptorp2.csv" #delets for stability