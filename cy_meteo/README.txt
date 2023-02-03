Welcome to the project cy_meteo by Dawid and Jeremy

to use the progam you need to check if every .sh and .c files in ./Program have permitions to execute

then you can go in the terminal in ./Program/ and type ./Main.sh <options> <arguments>
to get more details of what you can use type ./Main.sh --help

to make the program work you need to put the file.csv in ./Program/CSV_Starting_files
then when you use ./Main.sh you need to put -f file.csv you don't neet to worry about adding /CSV_Starting_files this option is manditory !

types of sorting <options> = -p<arg>; -h; -t<arg>; -m; -w; -h at least one is requiered to run
method of sorting <options>= --tab; --abr; --avl only one or none can be chosen at a time
optional values can be entered to limit the csv file -d<arg1><arg2> -a<arg1><arg2> -g<arg1><arg2>
You can also limit the zones with -F -G -S -A -O -Q

and example of a code is 
./Main.sh -t 1 -a 10 69 -d 2010-12-03 2015-03-24 -f file.csv
or 
./Main.sh -g -12 40 -f file.csv -d 2010-12-03 2015-03-24 -p 1