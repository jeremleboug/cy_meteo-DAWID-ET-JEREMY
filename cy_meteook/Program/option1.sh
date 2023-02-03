#!/bin/bash
#t1/p1

rm -f "$2" # makes sure the touched file doesn't exist 

./main -f $1 -o "../temp_sorted/$4.csv" $5 # sorts the file

input_file="../temp_sorted/$4.csv" # variable used for input  
output_file="$2"  # variable used for output
touch "$output_file" # opening to write in output
count='0' # count variable
firstvar=''
tempvariable='' # variables used to stock specific values
tempvariable2='' # variables used to stock specific values
min='0' # min def
max='0' # max def
avrage='' # avrage def
notfirst='0' 
temp='0' # temporary variable
tempearray=() # array used to hold variables
arraytemp='0' # verifs

# Loop through each line of the input file
while read -r L || [[ -n "$L" ]]; 
do
    if [ "$notfirst" -ne '0' ];
    then
        # for loop that goes through the caracters of the line
        for (( i=0; i<${#L}; i++ )); 
        do
            # puts the characters we want into variables
            if [ "$count" -eq "0" ];
            then
                if [ ! ${L:$i:1} = ';' ]
                then
                    tempvariable=$tempvariable${L:$i:1}
                fi
            fi
            if [ "${L:$i:1}" = ";" ]; 
            then
                count=$((count+1))
            elif [ "$count" = "$3" ];
            then
                tempvariable2=$tempvariable2${L:$i:1}
            fi
        done
        #echo "tempe =${tempearray[@]}" # uncomment if you want to see the array progress
        if [ "$firstvar" = '' ];
        then
            firstvar=$tempvariable
            if [ ! "$tempvariable2" = '' ];
            then
                tempearray+=("$tempvariable2")
            fi
            tempvariable2=''
            firstvartemp=$tempvariable
        else
            if [ "$firstvar" -eq "$tempvariable" ];
            then
                firstvartemp=$tempvariable
                if [ ! "$tempvariable2" = '' ];
                then
                    tempearray+=("$tempvariable2")
                fi
                tempvariable2=''
            else
                temp=$((temp+1))
                firstvar=$tempvariable
            fi
        fi
        sum='0'
        #assigns the min and max value   
        min=${tempearray[0]}
        max=${tempearray[0]}
        if [ "$temp" -ne "$arraytemp" ];
        then 
            arraytemp=$((arraytemp+1))
            for i in "${tempearray[@]}";
            do
                if [[ $(echo "$i > $max" | bc) -eq 1 ]]; #float comparators 
                then
                    max=$i # calculates maximum
                fi
                if [[ $(echo "$i < $min" | bc) -eq 1 ]]; #float comparators 
                then
                    min=$i # calculates minimum
                fi
                sum=$(echo "$sum + $i" | bc) # calculates sum
            done
            array_length=${#tempearray[@]} #array length
            avrage=$(echo "$sum / $array_length" | bc -l) #calculates avrage with float numbers
            echo "$firstvartemp;$min;$max;$avrage" >> "$output_file" #writes in output
            firstvartemp=$firstvar
            # assign's a new array based on if the variable is empty or not
            if [ ! "$tempvariable2" = '' ];
            then
                tempearray=("$tempvariable2")
            else
                tempearray=()
            fi
            tempvariable2=''
            sum='0'
        fi
        tempvariable=''
        count='0'
    else
        notfirst='1'
        echo "ID OMM station;min;max;moy" >> "$output_file"
    fi
done < "$input_file"
#echo "tempe =${tempearray[@]}" # uncomment if you want to see the array progress
echo "${#tempearray[@]}"
min=${tempearray[0]}
max=${tempearray[0]}
echo "min=$min max=$max"
for i in "${tempearray[@]}";
do
    if [[ $(echo "$i > $max" | bc) -eq 1 ]];
    then
        max=$i
    fi
    if [[ $(echo "$i < $min" | bc) -eq 1 ]];
    then
        min=$i
    fi
    sum=$(echo "$sum + $i" | bc)
done
#echo " i = $i ; max = $max ; min = $min"
array_length=${#tempearray[@]}
echo "leng =${#tempearray[@]} sum =$sum"
avrage=$(echo "$sum / $array_length" | bc -l)
echo "$firstvar;$min;$max;$avrage" >> "$output_file"
if [ ! "$tempvariable2" = '' ];
    then
        tempearray=("$tempvariable2")
    fi
tempvariable2=''
sum='0'
exec 3<&- #closes files
exec 4<&- #closes files

#if condition to determin the name of the graph variables
if [ "$4" = "t1" ]; 
then 
    name='Temperature'
else
    name='Pressure'
fi

# graph creation
rm -f ../temp/comands.txt #delets for stability
commands="../temp/comands.txt" # makes a txt file that executes commands
echo "set terminal png" >> $commands #tells the program to do a png
echo "#!/usr/bin/gnuplot -persist" >> $commands
echo "# set terminal pngcairo  transparent enhanced font "arial,10" fontscale 1.0 size 600, 400 " >> $commands 
echo "set output '../Graph/Graph_$4.png'" >> $commands # sets destination
echo "set xlabel 'ID OMM station'" >> $commands  #sets labels
echo "set ylabel '$name'" >> $commands #sets labels
echo "set datafile separator ';'" >> $commands # tells how the file is beeing separated
echo "set title '$4'" >> $commands # sets titles
echo "Shadecolor = '#80E0A080'" >> $commands # sets shadecolor color
echo "set yrange [*:*]" >> $commands # sets range to lowest and bigest
echo "set xrange [*:*]" >> $commands # sets range to lowest and bigest
# makes the graph
echo "plot '$output_file' every ::1 using 1:3:2 with filledcurve fc rgb Shadecolor title 'error margin', '' using 1:4 with line lw 2 title 'avrage'" >> $commands

gnuplot -persist -e "load '$commands'" #executes as gnuplot 

echo "graph created"