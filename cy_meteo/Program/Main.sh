#!/bin/bash

#-----------------------------------------------------folder integrity check------------------------------------------------------#

rm -rf "../temp/*" #delets temporary files to avoid conflicts
rm -rf "../temp_sorted/*" #delets temporary files to avoid conflicts
cd "$(dirname "$0")" #makes sure that the terminal is positioned at the shell script location

clear # aestetics
echo "For more details about how to use the program use argument '--help'" #for more help

# verifies that arguments are given
if [ $# -eq 0 ]; 
  then
    echo "Error: No arguments provided"
    exit 1
fi

# creates temp folder if it doesn't exist
if [ ! -d ../temp ]; 
then 
    mkdir ../temp
fi

# creates temp_sorted folder if it doesn't exist
if [ ! -d ../temp_sorted ]; 
then 
  mkdir ../temp_sorted
fi

# veriifies that the sorting program was compiled
if [ ! -e main ]; 
then 
  make # compiles if it hasn't
  echo "The Sorting program has been compiled"
fi

#-----------------------------------------------declaration of fonctions----------------------------------------------------------#

# types of sorting = -p; -h; -t; -m; -w; -h
# method of sorting = --tab; --abr; --avl
verif='0' # variable used for checking if at least one type of sorting is chosen 
fl='0' # variable used for checking if there is only one region restriction 
verifdouble='0' # variable used for checking if only one method of sorting is chosen 
necessary='0' # variable used to check if a file is given to sort
tri='--avl' # variable set to 3 as default sorting type is AVL
argumentarray=() # array used to hold the types of sorting 
soloarray=() # array used to hold argumentarry without duplicate
maxlat='90' # variable of the maximum latitude 
minlat='-90' # variable of the minimum latitude
maxlong='180' # variable of the maximum longitude
minlong='-180' # variable of the minimum longitude
timeverif='0' # variable used to check if only one -d has been used
latverif='0' # variable used to check if only one -a has been used
longiver='0' # variable used to check if only one -g has been used
count='0' # variable used to help with positioning in the for loop
validarg='0' # variable used to determin if a number is added that shouldn't be
intarg='0' # variable used to determin if a number is added that shouldn't be
wordvar='' # variable used to determin the word position
latlonverif='0' # variable used to help with latitude and longitude constraints
latval='' # variable used to extract the latitude from a csv file
longval='' # variable used to extract the longitude from a csv file
notfirst='0' # variable used for not taking the first line in a csv file
temp='0' # temporary variable
once='0' # variable used to make sure no more arguments were gien then necessary
mind='2010-00-00' # variable defining minimum date
maxd='2022-12-31' # variable defining maximum date


#----------------------------------------------------for loop for argument checking-----------------------------------------------#

# for loop to look through all the arguments
for arg in "$@"
do
  count=$((count+1)) # used for shifting by the amount that is needed
  # loop to see how many arguments start with a number
  if [[ "${arg:0:1}"  =~ ^[0-9]+$ ]];
  then
    intarg=$((intarg+1))
  fi
  # loop used to count how many arguments are valid
  if [ "$once" -eq "1" ] && [ "$validarg" -ne "$intarg" ];
  then
    validarg=$((validarg+1))
    once='0'
  fi
  # if user inputed -d 
  if [ "$arg" = '-d' ];
  then
    # generates error if two -d have been inputed
    if [ $timeverif -ne '0' ];
    then
      clear
      echo "Error : -d can only be mentioned once"
      exit 1
    fi
    timeverif=$((timeverif+1))
    shift $count #moves the $ variables by count
    count='0'
    temporery=$1 # gives temporery the value of the first argument after -d
    #checks if it starts with a number
    if [[ ${temporery:0:1}  =~ ^[0-9]+$ ]];
    then
      mind="$1"
      validarg=$((validarg+1))
    else 
      clear
      echo "Error : you need to input a min number in -d check < --help > for more details"
      exit 1
    fi 
    temporery=$2 # gives temporery the value of the second argument after -d
    #checks if it starts with a number
    if [[ ${temporery:0:1}  =~ ^[0-9]+$ ]] ;
    then
      maxd="$2"
      once='1'
    else 
      clear
      echo "Error : you need to input a max number in -a check < --help > for more details"
      exit 1
    fi
    temporery=$3 # checks if to to manny arguments were given
    if [[ ${temporery:0:1}  =~ ^[0-9]+$ ]] && [ "$once" -eq '2' ];
    then
      clear
      echo "Error : you cannot input more then 2 arguments with -d"
      exit 1
    fi  
    echo "min = $mind max = $maxd"
  # if user inputed -d
  elif [ "$arg" = '-a' ];
  then
    # error verifications
    if [ $latverif -ne '0' ];
    then
      clear
      echo "Error : -a can only be mentioned once"
      exit 1
    fi
    latverif=$((latverif+1))
    shift $count #moves the $ variables by count
    count='0'
    # checking if the arguments were given correctly
    if [[ $1  =~ ^[0-9]+$ ]];
    then
      mina="$1"
      validarg=$((validarg+1))
    else 
      clear
      echo "Error : you need to input a min number in -a check < --help > for more details"
      exit 1
    fi  
    if [[ $2  =~ ^[0-9]+$ ]];
    then
      maxa="$2"
      once='1'
    else 
      clear
      echo "Error : you need to input a max number in -a check < --help > for more details"
      exit 1
    fi
    if [[ $3  =~ ^[0-9]+$ ]];
    then
      clear
      echo "Error : you cannot input more then 2 arguments with -d"
      exit 1
    fi  
    if [ $mina -ge $maxa ];
    then
      clear
      echo "Error : the minimum cannot be equal or greater then the maximum"
      exit 1
    fi
    echo "min = $mina max = $maxa"
    minlat=$mina
    maxlat=$maxa
  # if user inputed -g
  elif [ "$arg" = '-g' ];
  then
    # checks if user typed -g multiple times
    if [ $longiver -ne '0' ];
    then
      clear
      echo "Error : -g can only be mentioned once"
      exit 1
    fi
    longiver=$((longiver+1))
    shift $count #moves the $ variables by count
    count='0'
    # checks if the user inputed a correct amount of arguments
    if [[ $1  =~ ^[0-9]+$ ]];
    then
      ming="$1"
      validarg=$((validarg+1))
    else 
      clear
      echo "Error : you need to input a min number in -g check < --help > for more details"
      exit 1
    fi  
    if [[ $2  =~ ^[0-9]+$ ]];
    then
      maxg="$2"
      once='1'
    else 
      clear
      echo "Error : you need to input a max number in -a check < --help > for more details"
      exit 1
    fi
    if [[ $3  =~ ^[0-9]+$ ]];
    then
      echo "Error : you cannot input more then 2 arguments with -g"
      exit 1
    fi  
    if [ $ming -ge $maxg ];
    then
      clear
      echo "Error : the minimum cannot be equal or greater then the maximum"
      exit 1
    fi
    echo "min = $ming max = $maxg"
    minlong=$ming
    maxlong=$maxg
  # if user inputed -f
  elif [ "$arg" = '-f' ];
  then
    necessary='1'
    shift $count #moves the $ variables by count
    count='0'
    file="CSV_Starting_files/$1" #inputs the file used in a variable
    echo "File name : $file"
    # if file doesn't exist
    if [ ! -e $file ];
    then
      clear
      echo "$file"
      echo "Error : file name does not exist"
      exit 1
    fi
  # if user inputed -t
  elif [ "$arg" = '-t' ];
  then
    shift $count #moves the $ variables by count
    count='0'
    # checks if correct argument was given
    if [[ $1  =~ ^[0-9]+$ ]];
    then
      tempe="$1"
      validarg=$((validarg+1))
    else 
      clear
      echo "Error : you need to input a argument in -t check < --help > for more details"
      exit 1
    fi
    echo "Option -t$tempe selected"
    if [ "$tempe" -ne "1" ] && [ "$tempe" -ne "2" ] && [ "$tempe" -ne "3" ];
    then
      clear
      echo "Error : '$tempe' not a valid argument for -t"
      exit 1
    fi
    verif=1
    argumentarray+=("t$tempe")
  # if user inputed -p
  elif [ "$arg" = '-p' ];
  then
    shift $count #moves the $ variables by count
    count='0'
    #checks if correct arguement was given
    if [[ $1  =~ ^[0-9]+$ ]];
    then
      press="$1"
      validarg=$((validarg+1))
    else 
      clear
      echo "Error : you need to input a argument in -p check < --help > for more details"
      exit 1
    fi
    echo "Option -p$press selected"
    if [ "$press" -ne "1" ] && [ "$press" -ne "2" ] && [ "$press" -ne "3" ];
    then
      clear
      echo "Error : '$press' not a valid argument for -p"
      exit
    fi
    verif=1
    argumentarray+=("p$press")
  # if user inputed -w
  elif [ "$arg" = '-w' ];
  then
    echo "Option -w selected"
    verif=1
    argumentarray+=("w")
  # if user inputed -m
  elif [ "$arg" = '-m' ];
  then
    echo "Option -m selected"
    verif=1
    argumentarray+=("m")
  # if user inputed -h
  elif [ "$arg" = '-h' ];
  then
    echo "Option -h selected"
    verif=1
    argumentarray+=("h")
  # if user inputed -F
  elif [ "$arg" = '-F' ];
  then
    fl=$((fl+1)) # verifies if only one World argument was given
    echo "Option F selected"
    minlong='6'
    maxlong='11'
    minlat='38'
    maxlat='51'
    wordvar='F'
  # if user inputed -G
  elif [ "$arg" = '-G' ];    
  then
    fl=$((fl+1)) # verifies if only one World argument was given
    echo "Option G selected"
    minlong='-62'
    maxlong='-49'
    minlat='0'
    maxlat='9'
    wordvar='G'
  # if user inputed -S
  elif [ "$arg" = '-S' ];
  then
    fl=$((fl+1)) # verifies if only one World argument was given
    echo "Option S selected"
    minlong='-60'
    maxlong='-51'
    minlat='46'
    maxlat='52'
    wordvar='S'
  # if user inputed -A
  elif [ "$arg" = '-A' ];
  then
    fl=$((fl+1)) # verifies if only one World argument was given
    echo "Option A selected"
    minlong='-66'
    maxlong='-56'
    minlat='11'
    maxlat='19'
    wordvar='A'
  # if user inputed -O
  elif [ "$arg" = '-O' ];
  then
    fl=$((fl+1)) # verifies if only one World argument was given
    echo "Option O selected"
    minlong='35'
    maxlong='91'
    minlat='-53'
    maxlat='-41'
    wordvar='O'
  # if user inputed -Q
  elif [ "$arg" = '-Q' ];
  then
    fl=$((fl+1)) # verifies if only one World argument was given
    echo "Option O selected"
    maxlat='-54'
    wordvar='Q'
  # if user inputed --help
  elif [ "$arg" = '--help' ];
  then
    clear
    cat manual.txt # inputs the manual into the terminal
    exit 1
  # if user inputed --tab
  elif [ "$arg" = '--tab' ];
  then
    echo "Sorting method used <liste chainée>" # choses tab sorting option
    tri='--tab' 
    verifdouble=$((verifdouble+1))
  # if user inputed --abr
  elif [ "$arg" = '--abr' ];
  then
    echo "Sorting method used <ABR>" # choses abr sorting option
    tri='--abr'
    verifdouble=$((verifdouble+1))
  # if user inputed --avl
  elif [ "$arg" = '--avl' ];
  then
    echo "Sorting method used <AVL>" # choses avl sorting option
    tri='--avl'
    verifdouble=$((verifdouble+1))
  # if user inputed a incorrect comand
  elif [[ ${arg:0:1} =~ ^[0-9]+$ ]] && [ ! "$arg" = "$file" ] && [ "$validarg" -ne "$intarg" ];
  then
    clear
    echo "Error : Invalid option or argument check '--help' " 
    exit 1
  fi
  if [ $fl -gt 1 ];
  then
    clear
    echo "Error : you inputed more option then possible only one of these can be inputed -F -G -S -A -O -Q"
    exit 1
  fi
  temporery='0'
done

# checks if a type of sorting is selected
if [ "$verif" -ne '1' ];
then
  clear
  echo "Error : you need to select a sorting type -t <1-3>; -p <1-3>; -h; -m; -w"
  exit 1
fi

# checks if if more then one methon of sorting is inputed
if [ "$verifdouble" -gt '1' ];
then
  clear
  echo "Error : you are not allowed to enter multiple sorting arguments"
  exit 1
fi

# checks if a file name has been inputed
if [ "$necessary" -ne '1' ];
then
  clear
  echo "Error : you are requiered to put in -f <file_name>"
  exit 1
fi

# checks if date inputed is valid
if [ ! "${mind:0:1}" = "2" ] || [ ! "${mind:1:1}" = "0" ] || [ ! "${mind:2:1}" -ge "1" ] || [ ! "${mind:2:1}" -le "2" ] || ! [[ "${mind:2:1}" =~ [0-9] ]] || ! [[ "${mind:3:1}" =~ [0-9] ]] || [ ! "${mind:4:1}" = '-' ] || [ ! "${mind:5:1}" -ge "0" ] || [ ! "${mind:5:1}" -le "3" ] || ! [[ "${mind:5:1}" =~ [0-9] ]] || ! [[ "${mind:6:1}" =~ [0-9] ]] || [ ! "${mind:7:1}" = '-' ] || [ ! "${mind:8:1}" -ge "0" ] || [ ! "${mind:8:1}" -le "3" ] || ! [[ "${mind:8:1}" =~ [0-9] ]] || ! [[ "${mind:9:1}" =~ [0-9] ]];
then
  clear
  echo "Error minimum date not inputed correctly check '--help'"
  exit 1
fi

# checks if date inputed is valid
if [ ! "${maxd:0:1}" = "2" ] || [ ! "${maxd:1:1}" = "0" ] || [ ! "${maxd:2:1}" -ge "1" ] || [ ! "${maxd:2:1}" -le "2" ] || ! [[ "${maxd:2:1}" =~ [0-9] ]] || ! [[ "${maxd:3:1}" =~ [0-9] ]] || [ ! "${maxd:4:1}" = '-' ] || [ ! "${maxd:5:1}" -ge "0" ] || [ ! "${maxd:5:1}" -le "3" ] || ! [[ "${maxd:5:1}" =~ [0-9] ]] || ! [[ "${maxd:6:1}" =~ [0-9] ]] || [ ! "${maxd:7:1}" = '-' ] || [ ! "${maxd:8:1}" -ge "0" ] || [ ! "${maxd:8:1}" -le "3" ] || ! [[ "${maxd:8:1}" =~ [0-9] ]] || ! [[ "${maxd:9:1}" =~ [0-9] ]];
then
  clear 
  echo "Error maximum date not inputed correctly check '--help'"
  exit 1
fi

# checks if date inputed in correct order
if [ "${mind:2:1}" -gt "${maxd:2:1}" ];
then
  clear
  echo "Error : maximum date cannot be earlier then minimum date"
  exit 1
elif [ "${mind:2:1}" -eq "${maxd:2:1}" ];
then
  if [ "${mind:3:1}" -gt "${maxd:3:1}" ];
  then
    clear
    echo "Error : maximum date cannot be earlier then minimum date"
    exit 1
  elif [ "${mind:5:1}" -gt "${maxd:5:1}" ] && [ "${mind:3:1}" -eq "${maxd:3:1}" ];
  then
    clear
    echo "Error : maximum date cannot be earlier then minimum date"
    exit 1
  elif [ "${mind:5:1}" -eq "${maxd:5:1}" ];
  then
    if [ "${mind:6:1}" -gt "${maxd:6:1}" ];
    then
      clear
      echo "Error : maximum date cannot be earlier then minimum date"
      exit 1
    elif [ "${mind:8:1}" -gt "${maxd:8:1}" ] && [ "${mind:6:1}" -eq "${maxd:6:1}" ];
    then
      clear
      echo "Error : maximum date cannot be earlier then minimum date"
      exit 1
    elif [ "${mind:8:1}" -eq "${maxd:8:1}" ];
    then
      if [ "${mind:9:1}" -gt "${maxd:9:1}" ];
      then
        clear
        echo "Error : maximum date cannot be earlier then minimum date"
        exit 1
      fi
    fi
  fi
fi

# loop for to eliminate duplicates
for arg in "${argumentarray[@]}"; 
do
  count='0'
  for soloarg in "${soloarray[@]}"; 
  do
    if [ "$arg" = "$soloarg" ];
    then 
      count='1'
    fi
  done
  if [ "$count" -eq "0" ];
  then 
    soloarray+=("$arg")
  fi
done

echo "solo element array: ${soloarray[@]}"

output_file="../temp/temp1.csv" #temporary file used to eliminate unwanted variables
input_file=$file

# if checks if the coordinates have been changed
if [ "$maxlat" -ne '90' ] || [ "$minlat" -ne '-90' ] || [ "$maxlong" -ne "180" ] || [ "$minlong" -ne "-180" ];
then
  touch "$output_file"
  count='0'
  # while loop that goes restricts coordinates
  while read -r line || [[ -n "$line" ]]; 
  do
    temp=$((temp+1))
    # if condition that doesn't take the first line into account
    if [ "$notfirst" -ne '0' ];
    then
      #for loop through the caracters in the line 
      for (( i=0; i<${#line}; i++ )); 
      do
        if [ "${line:$i:1}" = ";" ]; 
        then
          count=$((count+1))
        elif [ "$count" = '9' ];
        then 
          if [ "${line:$i:1}" = "," ];
          then 
            latlonverif='1'
          elif [ "$latlonverif" -eq '0' ];
          then 
            latval=$latval"${line:$i:1}"
          else
            longval=$longval"${line:$i:1}"
          fi
        fi
      done
      count='0'
      latlonverif='0'
      if [[ $(echo "$minlat <= $latval" | bc) -eq 1 ]] && [[ $(echo "$maxlat >= $latval" | bc) -eq 1 ]] && [[ $(echo "$minlong <= $longval" | bc) -eq 1 ]] && [[ $(echo "$maxlong >= $longval" | bc) -eq 1 ]];
      then
          echo "$line" >> "$output_file"
          #echo "L$temp latval=$latval, longval=$longval maxlat=$maxlat minlat=$minlat maxlong=$maxlong minlong=$minlong"
      fi
      latval=''
      longval=''
    else # prints the first line in the output
      notfirst='1'
      echo "$line" >> "$output_file"
    fi
  done < "$input_file"
  exec 3<&-
  exec 4<&-
  echo "File conversion complete."
  input_file=$output_file
  output_file="../temp/temp2.csv"
fi

# if checks if the date has been changed
if [ ! "$mind" = '2010-00-00' ] || [ ! "$maxd" = '2022-12-31' ];
then
  touch "$output_file" #writes in output file
  count='0'
  notfirst='0'
  tempdateval=''
  dateverif='0'
  year='' # year variable
  month='' # month varilabe
  day='' # day variable
  count2='0'
  # loop through the inputed file
  while read -r line || [[ -n "$line" ]]; 
  do
    # checks if it's the first line
    if [ "$notfirst" -ne '0' ];
    then
      # for loop that goes through every character of the line
      for (( i=0; i<${#line}; i++ )); 
      do
        # counts at which colomun the program is
        if [ "${line:$i:1}" = ";" ]; 
        then
          count=$((count+1))
        # if the program is at the date column
        elif [ "$count" = '1' ];
        then 
          # separates the date into year/month/day variables
          if [ "${line:$i:1}" = '-' ];
          then 
            count2=$((count2+1))
          elif [ "${line:$i:1}" = "T" ];
          then 
            dateverif='1'
          else
            if [ "$dateverif" -eq '0' ];
            then
              if [ "$count2" -eq '0' ];
              then
                year=$year${line:$i:1}
              elif [ "$count2" -eq '1' ];
              then
                month=$month${line:$i:1}
              elif [ "$count2" -eq '2' ];
              then
                day=$day${line:$i:1}
              fi
            fi
          fi
        fi
      done
      count2='0'
      canioutput='0'
      # filters the dates
      if [ "${mind:0:4}" -lt "$year" ] && [ "${maxd:0:4}" -gt "$year" ];
      then
        echo "$line" >> "$output_file"
      fi
      if [ "${mind:0:4}" -eq "$year" ] || [ "${maxd:0:4}" -eq "$year" ]; 
      then
        canioutput=$((canioutput+1))
        if [ "${maxd:0:4}" -gt "$year" ];
        then
          if [ "${mind:5:2}" -lt "$month" ];
          then
            echo "$line" >> "$output_file"
          fi
        elif [ "${maxd:5:2}" -gt "$month" ] && [ "${mind:5:2}" -lt "$month" ];
        then
          echo "$line" >> "$output_file"
        fi
        if [ "${mind:5:2}" -eq "$month" ] || [ "${maxd:5:2}" -eq "$month" ];
        then
          canioutput=$((canioutput+1))
          if [ "${maxd:5:2}" -gt "$month" ];
          then
            if [ "${mind:8:2}" -lt "$day" ];
            then
              echo "$line" >> "$output_file"
            fi
          elif [ "${maxd:8:2}" -gt "$day" ] && [ "${mind:8:2}" -lt "$day" ];
          then
            echo "$line" >> "$output_file"
          fi
          if [ "${mind:8:2}" -eq "$day" ] || [ "${maxd:8:2}" -eq "$day" ];
          then
            canioutput=$((canioutput+1))
          fi
        fi
      else
        clear 
        echo "Error : something went wrong" # not a valid Error
      fi
      # if the date is equal to the max or min date 
      if [ "$canioutput" -eq '3' ];
      then
          echo "$line" >> "$output_file" 
      fi
      canioutput='0'
      tempdateval=''
      count='0'
    else
      notfirst='1'
      echo "$line" >> "$output_file"
    fi
    dateverif='0'
    year=''
    month=''
    day=''
  done < "$input_file"
  exec 3<&-
  exec 4<&-
fi

# treats the inputed sorting types
for type in "${soloarray[@]}";
do
  if [ $type = "t1" ];
  then
    ./option1.sh $file ../temp_sorted/$type$wordvar 10 $type$wordvar $tri
  fi
  if [ $type = "t2" ];
  then
    ./option2.sh $file ../temp_sorted/$type$wordvar 10 $type$wordvar $tri
  fi
  if [ $type = "t3" ];
  then
    ./option3.sh $file ../temp_sorted/$type$wordvar 10 $type$wordvar $tri
  fi
  if [ $type = "p1" ];
  then
    ./option1.sh $file ../temp_sorted/$type$wordvar 6 $type$wordvar $tri
  fi
  if [ $type = "p2" ];
  then
    ./option2.sh $file ../temp_sorted/$type$wordvar 6 $type$wordvar $tri
  fi
  if [ $type = "p3" ];
  then
    ./option3.sh $file ../temp_sorted/$type$wordvar 6 $type$wordvar $tri
  fi
  if [ $type = "w" ];
  then
    ./wind.sh $file ../temp_sorted/$type$wordvar $type$wordvar $tri
  fi
  if [ $type = "h" ];
  then
    ./HaltMoist.sh $file ../temp_sorted/$type$wordvar Haltitude 1 $type$wordvar $tri
  fi
  if [ $type = "m" ];
  then
    ./HaltMoist.sh $file ../temp_sorted/$type$wordvar Moisture 0 $type$wordvar $tri
  fi
done