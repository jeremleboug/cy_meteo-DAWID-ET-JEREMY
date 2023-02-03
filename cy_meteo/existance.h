//this function returns true if he has a right son
bool exist_fg(PTree a){
    return (a->fg ? true : false);
}
//this function returns true if he has a left son
bool exist_fd(PTree a){
    return (a->fd ? true : false);
}
//this function returns true if the tree is empty
bool is_empty(PTree a){
    return(a == NULL);
}
//this function returns true if the node has no children
bool is_paper(PTree a){
    return(a && !(a->fg || a->fd));
}
