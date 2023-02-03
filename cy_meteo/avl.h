//this function traverses a tree in an ascending manner
void parcours_infixe(PTree a){
    if(a != NULL){
        parcours_infixe(a->fg);
        printf("%d ", a->elmt);
        parcours_infixe(a->fd);
    }
}
PTree create_tree(Element e){//creation Tree
    PTree a;
    a = malloc(sizeof(Tree));
    if(a == NULL){
        exit(1);
    }
    
    *a = (Tree) {e, NULL, NULL, 0};
    
    return a;    
}
//this function returns the value of the height of a tree
int height(PTree a){
    if(a == NULL){
        return 0;
    }
    return a->height;
}
int equilibre(PTree a){
    if(a == NULL){
        return 0;
    }
    return height(a->fg) - height(a->fd);
}
//this function rotates the tree to the right by changing the smallest right son to the root
PTree right_rotate(PTree y){
    PTree c = y->fg;
    PTree d = c->fd;
    c->fd = y;
    y->fg = d;
    y->height = max(height(y->fd), height(y->fg))+1;
    c->height = max(height(c->fd), height(c->fg))+1;
    return c;
}
//this function rotates the tree to the left by changing the smallest left child to the root
PTree left_rotate(PTree c){
    PTree b = c->fd;
    PTree d = b->fg;
    b->fg = c;
    c->fd = d;
    b->height = max(height(b->fd), height(b->fg))+1;
    c->height = max(height(c->fd), height(c->fg))+1;
    return b;
}
//this function inserts a node and rotates it when the element of the node to insert is too small
PTree insert_avl(PTree a , int e){
    if(a == NULL){
        return create_tree(e);
    }
    if(e < a->elmt){
        a->fg = insert_avl(a->fg, e);
    }
    else if(e > a->elmt){
        a->fd = insert_avl(a->fd, e);
        return a;
    }
    a->height = 1 + max(height(a->fg), height(a->fd));
    int equilib = equilibre(a);
    if(equilib>1 && e <a->fg->elmt){
        right_rotate(a);
    }
    if(equilib<-1 && e <a->fg->elmt){
        a->fd = right_rotate(a->fd);
        left_rotate(a);
    }
    if(equilib<-1 && e >a->fd->elmt){
        left_rotate(a);
    }
    if(equilib>1 && e >a->fd->elmt){
        a->fg = left_rotate(a->fg);
        right_rotate(a);
    }
    return a;
}
