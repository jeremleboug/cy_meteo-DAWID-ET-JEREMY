//this function writes in the output file by traversing in an increasing way the tree 
void ascending_course(PTree a, FILE *fp_out){
    if(! is_empty(a)){
        ascending_course(a->fd, fp_out);
        fprintf(fp_out, "%d\n", a->elmt);
        printf("%d-", a->elmt);
        ascending_course(a->fg, fp_out);
    }
}
//this function writes to the output file by going down the tree 
void descending_course_date(PTree a, FILE *fp_out){
    if(! is_empty(a)){
        descending_course_date(a->fg, fp_out);
          int number_hour = a->elmt;
            int year = number_hour/8760;
            int ryear = number_hour%8760;
            int mounth = (ryear/(730));
            int rmounth = ryear%730;
            int day = rmounth/24;
            int rday = rmounth%24;
            int hour = rday;
            fprintf(fp_out, "%d-%d-%dT%d:00:00+01:00\n", year, mounth, day, hour);
        descending_course_date(a->fd, fp_out);
    }
}
//this function writes to the output file by scrolling up the tree and changing hours to dates
void ascending_course_date(PTree a, FILE *fp_out){
    if(! is_empty(a)){
        ascending_course_date(a->fd, fp_out);
        int number_hour = a->elmt;
            int year = number_hour/8760;
            int ryear = number_hour%8760;
            int mounth = (ryear/(730));
            int rmounth = ryear%730;
            int day = rmounth/24;
            int rday = rmounth%24;
            int hour = rday;
            fprintf(fp_out, "%d-%d-%dT%d:00:00+01:00\n", year, mounth, day, hour);
        printf("%d-", a->elmt);
        ascending_course_date(a->fg, fp_out);
    }
}
//this function writes to the output file by scrolling down the tree and changing hours to dates
void descending_course(PTree a, FILE *fp_out){
    if(! is_empty(a)){
        descending_course(a->fg, fp_out);
        fprintf(fp_out, "%d\n", a->elmt);
        descending_course(a->fd, fp_out);
    }
}
