//this function returns the date in a number of hours
int date_to_hour(char date[]){
  int year;
  int mounth; 
  int day;
  int hour;
  char *token = strtok(date, "-");//anne
  year = atoi(token);
  token = strtok(NULL, "-");//mounth
    mounth = atoi(token);
  token = strtok(NULL, "T");//day
    day = atoi(token);
  token = strtok(NULL, ":");//hour
    hour = (8760 * year) + (730 * mounth)+(24 * day) + atoi(token);
  return hour;
}
//this function retrieves the string until the next ';'.
char* get_field(char* csv_line, int field_num) {
    static char field[100];
    int i;
    for (i = 0; csv_line[i] != ';' && csv_line[i] != '\0'; i++) {
        field[i] = csv_line[i];
    }
    field[i] = '\0';
    return field;
}
//this function performs an descending tri-bubble
void descending_sort_bubble(int tab[], int SIZE)
{
         int cell;
     int memory;
    int i=1; 
     int j=SIZE-1;
     while(i && j>0){
          i=0; 
    for(cell=0;cell<j;cell++){
        if(tab[cell]<tab[cell+1]){
            i=1;
            memory=tab[cell];
            tab[cell]=tab[cell+1];
            tab[cell+1]=memory;
        }
    }j--;}
}
//this function performs an ascending tri-bubble
void ascending_sort_bubble(int tab[], int SIZE)
{
        int cell;
        int memory;
        int i=1; 
        int j=SIZE-1;

     while(i && j>0){
    i=0; 
    for(cell=0;cell<j;cell++){
        if(tab[cell]>tab[cell+1]){
            i=1;
            memory=tab[cell];
            tab[cell]=tab[cell+1];
            tab[cell+1]=memory;
        }
        }
       j--;}
}
//this function displays the table
void display_tab(int tab[], int SIZE){
    for(int i = 0; i < SIZE ;i++){
        printf("%d ", tab[i]);
    }
}
