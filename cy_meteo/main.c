#include <stdio.h>
#include <stdlib.h>
#include <string.h> 
#include <time.h>
#include <unistd.h>
#include <ctype.h>
#include <math.h>
#include <stdbool.h>//importante bibliotheque!!!
//if x>y , return x. else : return y
#define max(x,y) \
       ({ typeof (x) _x = (x); \
           typeof (y) _y = (y); \
         _x > _y ? _x : _y; })
//if x<y , return x. else : return y
#define min(x,y) \
       ({ typeof (x) _x = (x); \
           typeof (y) _y = (y); \
         _x < _y ? _x : _y; })
typedef int Element;
typedef struct arb {
    Element elmt;//the value of the nod
    struct arb * fg;//left soon
    struct arb * fd;//right soon
    int balnce;//state of the tree in the avl
    int height;//height of the tree
}Tree;
typedef Tree * PTree;
//call of the headers
#include "existance.h"
#include "avl.h"
#include "abr.h"
#include "affichage_avl_abr.h"
#include "tab.h"
//============insertion part=========
//convert a string into an int
int string_to_int(const char *string) {
    int number = 0;
    int sign = 1;

    if (*string == '-') {
        sign = -1;
        string++;
    }

    while (*string != '\0') {
        int digit = *string - '0';
        if (digit < 0 || digit > 9) {
            break;
        }
        number = number * 10 + digit;
        string++;
    }

    return sign * number;
}
/*this function sorts an array of integer or date. the fp file is opened to get the data in strings. 
Then the data is converted to int and sorted by inserting it in an avl.*/
void insertion_AVL(FILE *fp,FILE *fp_out, char inputfile[], char outputfile[], PTree a, int choix_croiss_decroiss, int type){
    int choice_row = 4;
    char line[256];
    int number;
    if(type == 0){//int
    int i = 0;
        fp = fopen(inputfile, "r");
        char *token = get_field(line, choice_row);
        char buffer[1000];
        int count = sscanf(token, "%s", buffer);
        if(count < 1){
            printf("VIDE ");
        }
            i++;
            printf("%d ", atoi(token));
            insert_avl(a, i);
        parcours_infixe(a);
        fclose(fp);
        if(choix_croiss_decroiss == 0){
        printf("croissant\n");
        fp_out = fopen(outputfile, "w");
        ascending_course(a, fp_out);
        fclose(fp_out);
        }
        else{
        printf("decroissant\n");
        fp_out = fopen(outputfile, "w");
        //descending_course(a, fp_out);
        fclose(fp_out);
        }
    }
    else if(type == 1){//date
        printf("date : \n");
        fclose(fp);
        int number_hour;
        char date[1233];
        fp = fopen(inputfile, "r+");
        while (fgets(line, sizeof(line), fp) != NULL) {
            if (sscanf(line, "%s", date) == 1) {
            number_hour = date_to_hour(line);
            a = insert_avl(a, number_hour);
            } else {
            printf("VIDE");
            }
        }
        fclose(fp);
        if(choix_croiss_decroiss == 0){//ascending
        printf("croissant\n");
        fp_out = fopen(outputfile, "w");
        ascending_course_date(a, fp_out);
        fclose(fp_out);
        }
        else{//descending
        printf("decroissant\n");
        fp_out = fopen(outputfile, "w");
        descending_course_date(a, fp_out);
        fclose(fp_out);
        }
        fclose(fp_out);
        printf("\n");
    }
}
//this function sorts an array of integer or date. the fp file is opened to get the data in strings. Then the data is converted to int and sorted by inserting it in an abr.
void insertion_ABR(FILE *fp,FILE *fp_out, char inputfile[], char outputfile[], int choix_croiss_decroiss, int type){
    int choice_row = 4;
    char line[256];
    if(type == 0){//int
    fp = fopen(inputfile, "r");
        fgets(line, sizeof(line), fp);
        char *token = get_field(line, choice_row);
        PTree a = insertion(a, atoi(token));
        while (fgets(line, sizeof(line), fp) != NULL) {
            char *token = get_field(line, choice_row);
            char buffer[1000];
            int count = sscanf(token, "%s", buffer);
            if(count < 1){
                printf("VIDE ");
            }else if(count >=1){
                printf("%d  ", atoi(token));
                insertion(a, atoi(token));
            }
        }
        fclose(fp);
        if(choix_croiss_decroiss == 0){//croissant
        printf("croissant\n");
        fp_out = fopen(outputfile, "w");
        ascending_course(a, fp_out);
        fclose(fp_out);
        }
        else{//decroissant
        printf("decroissant\n");
        fp_out = fopen(outputfile, "w");
        descending_course(a, fp_out);
        fclose(fp_out);
        }
    }
    else if(type == 1){//date
        PTree a = insertion(a, 0);
        printf("date : \n");
        fclose(fp);
        int number_hour;
        char date[1233];
        fp = fopen(inputfile, "r+");
        while (fgets(line, sizeof(line), fp) != NULL) {
            if (sscanf(line, "%s", date) == 1) {
            number_hour = date_to_hour(line);
            insertion(a, number_hour);
            } else {
            printf("Error reading number\n");
            }
        }
        fclose(fp);
        if(choix_croiss_decroiss == 0){//croissant
        printf("ascending\n");
        fp_out = fopen(outputfile, "w");
        ascending_course_date(a, fp_out);
        fclose(fp_out);
        }
        else{//decroissant
        printf("descending\n");
        fp_out = fopen(outputfile, "w");
        descending_course_date(a, fp_out);
        fclose(fp_out);
        }
        fclose(fp_out);
        printf("\n");
    }
}
/*this function sorts an array of integer or date. the fp file is opened to
 get the data in strings. Then the data is converted to int and stored
  in an array which is then sorted.*/
void insertion_tab(FILE *fp,FILE *fp_out, char inputfile[], char outputfile[], PTree a, int choix_croiss_decroiss, int type){
    int choice_row = 4;
    char line[956];
    int SIZE = 0;
    int i = 0;
    fp = fopen(inputfile, "r+");      
    if(type == 0){
        while (fgets(line, sizeof(line), fp) != NULL) {
            SIZE++;
        }
        fclose(fp);
        int tab[SIZE];
        char *tab_adresse[SIZE];
        fp = fopen(inputfile, "r+");
        while (fgets(line, sizeof(line), fp) != NULL) {
            char *token = get_field(line, choice_row);
            char buffer[1000];
            int count = sscanf(token, "%s", buffer);
            if(count < 1){
                printf("VIDE ");SIZE--;
            }else if(count >=1){
                printf("%d  ", atoi(token));
                tab[i] = atoi(token);
                tab_adresse[i] = token;
                i++;
            }
        }
        printf("\n");
        display_tab(tab, SIZE);
        if(choix_croiss_decroiss == 0){printf("ascending");ascending_sort_bubble(tab, SIZE);}
        else{printf("descending");descending_sort_bubble(tab, SIZE);}
        fclose(fp);
        fp_out = fopen(outputfile, "w");
        for (int i = 0; i < SIZE; i++)
        {
            fprintf(fp_out, "%d\n", tab[i]);
        }
        fclose(fp_out);
        printf("\n");
        display_tab(tab, SIZE); 
    }
    else{//if it's a date
    printf("date : \n");
        while (fgets(line, sizeof(line), fp) != NULL) {
            SIZE++;
        }
        fclose(fp);
        int tab[SIZE];
        char date[1233];
        char *content[SIZE];
        fp = fopen(inputfile, "r+");
        while (fgets(line, sizeof(line), fp) != NULL) {
            if (sscanf(line, "%s", date) == 1) {
            tab[i] = date_to_hour(line);
            content[i] = date;
            printf("The date is: %s\n", content[i]);
            } else {
            printf("Error reading number\n");
            }
            i++;
        }
        if(choix_croiss_decroiss == 0){printf("ascending");ascending_sort_bubble(tab, SIZE);}
        else{printf("descending");descending_sort_bubble(tab, SIZE);}
        fclose(fp);
        fp_out = fopen(outputfile, "w");
        for(int i = 0 ; i< SIZE ; i++){
            int year = tab[i]/8760;
            int ryear = tab[i]%8760;
            int mounth = (ryear/(730));
            int rmounth = ryear%730;
            int day = rmounth/24;
            int rday = rmounth%24;
            int hour = rday;
            fprintf(fp_out, "%d-%d-%dT%d:00:00+01:00\n", year, mounth, day, hour);
            i++;
        }
        fclose(fp_out);
        printf("\n");
        display_tab(tab, SIZE);       
    }
}
//=================main function===============================
//this function initializes the output and input files. It looks at the arguments given by the user and performs one of the 6 possible functions.
int main(int argc, char *argv[]){
    FILE *fp;
    FILE *fp_out;
    PTree a = create_tree(0);
    int type = 0;// 0 = int    1 = date
    char *inputFile = NULL;
    char *outputFile = NULL;
    int choice_ascending_descending = 0;
    int sortOrder = 1; // 1 pour tri croissant, 0 pour tri décroissant
    int sortMethod = 0; // par défaut, utilise AVL
   for (int i = 1; i < argc; i++) {
        if (strcmp(argv[i], "-f") == 0 && i + 1 < argc) {
            inputFile = argv[++i];
        } else if (strcmp(argv[i], "-o") == 0 && i + 1 < argc) {
            outputFile = argv[++i];
        } else if (strcmp(argv[i], "-r") == 0) {
            choice_ascending_descending = 1;
        } else if (strcmp(argv[i], "--tab") == 0) {
            if (strcmp("Date.csv", inputFile) == 0){insertion_tab(fp,fp_out, inputFile, outputFile, a, choice_ascending_descending, 1);}
            else{insertion_tab(fp,fp_out, inputFile, outputFile, a, choice_ascending_descending, 0);}
        } else if (strcmp(argv[i], "--abr") == 0) {
            if (strcmp("Date.csv", inputFile) == 0){insertion_ABR(fp,fp_out, inputFile, outputFile, choice_ascending_descending, 1);}
            else{insertion_ABR(fp,fp_out, inputFile, outputFile, choice_ascending_descending, 0);}
        } else if (strcmp(argv[i], "--avl") == 0) {
            if (strcmp("Date.csv", inputFile) == 0){insertion_AVL(fp,fp_out, inputFile, outputFile, a, choice_ascending_descending, 1);}
            else{insertion_AVL(fp,fp_out, inputFile, outputFile, a, choice_ascending_descending, 0);}
        } else {
            printf("Option non reconnue : %s\n", argv[i]);
        }
    }
    if (inputFile == NULL || outputFile == NULL) {
        printf("Les options -f et -o sont obligatoires.\n");
        return 1;
    }
    fp = fopen(inputFile, "r+");
    if (fp == NULL) {
        printf("Erreur lors de l'ouverture du fichier");
        return 2;
    }
    int choice_row = 4;
    char line[256];
    fclose(fp);
    printf("\n");
    return 0;
}