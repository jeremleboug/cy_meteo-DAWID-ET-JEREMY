
//add a left soon
PTree add_fg(PTree a, Element e){
    if(! (is_empty(a)||exist_fg(a))){
        a->fg  =create_tree(e);
        
    }
    return a;
}
//adds a right son
PTree add_fd(PTree a, Element e){
    if(! (is_empty(a)||exist_fd(a))){
        a->fd = create_tree(e);
        
    }
    return a;
}
//this function is the same that insertion_ascending
PTree insertion(PTree a, int e){
    
    if(is_empty(a)){
        return create_tree(e);
    }
    else if(e> a->elmt){
        a->fg = insertion(a->fg, e);
    }
    else{
        a->fd = insertion(a->fd, e);
    }
    return a;
}
//this function inserts a branch in the abr in an increasing way
PTree insertion_ascending(PTree a, int e){
    
    if(is_empty(a)){
        return create_tree(e);
    }
    else if(e> a->elmt){
        a->fd = insertion_ascending(a->fd, e);
    }
    else{
        a->fg = insertion_ascending(a->fg, e);
    }
    return a;
}
//this function inserts a branch in the abr in decreasing order
PTree insertion_descending(PTree a, int e){
    if(is_empty(a)){
        return create_tree(e);
    }
    else if(e< a->elmt){
        a->fg = insertion_descending(a->fg, e);
    }
    else{
        a->fd = insertion_descending(a->fd, e);
    }
    return a;
}
