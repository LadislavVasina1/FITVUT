/*
 * Binárny vyhľadávací strom — iteratívna varianta
 *
 * S využitím dátových typov zo súboru btree.h, zásobníkov zo súborov stack.h a
 * stack.c a pripravených kostier funkcií implementujte binárny vyhľadávací
 * strom bez použitia rekurzie.
 */

#include "../btree.h"
#include "stack.h"
#include <stdio.h>
#include <stdlib.h>

/*
 * Inicializácia stromu.
 *
 * Užívateľ musí zaistiť, že incializácia sa nebude opakovane volať nad
 * inicializovaným stromom. V opačnom prípade môže dôjsť k úniku pamäte (memory
 * leak). Keďže neinicializovaný ukazovateľ má nedefinovanú hodnotu, nie je
 * možné toto detekovať vo funkcii.
 */
void bst_init(bst_node_t **tree) {
  *tree = NULL;
}

/*
 * Nájdenie uzlu v strome.
 *
 * V prípade úspechu vráti funkcia hodnotu true a do premennej value zapíše
 * hodnotu daného uzlu. V opačnom prípade funckia vráti hodnotu false a premenná
 * value ostáva nezmenená.
 *
 * Funkciu implementujte iteratívne bez použitia vlastných pomocných funkcií.
 */
bool bst_search(bst_node_t *tree, char key, int *value) {
  return false;
}

/*
 * Vloženie uzlu do stromu.
 *
 * Pokiaľ uzol so zadaným kľúčom v strome už existuje, nahraďte jeho hodnotu.
 * Inak vložte nový listový uzol.
 *
 * Výsledný strom musí spĺňať podmienku vyhľadávacieho stromu — ľavý podstrom
 * uzlu obsahuje iba menšie kľúče, pravý väčšie.
 *
 * Funkciu implementujte iteratívne bez použitia vlastných pomocných funkcií.
 */
void bst_insert(bst_node_t **tree, char key, int value) {
  bst_node_t *tmp = *tree;
  bst_node_t *previous = NULL;
  bst_node_t *inserted = malloc(sizeof(bst_node_t));
  if(inserted == NULL){
    return;// malloc failnul
  }
  inserted->key = key;
  inserted->left = NULL;
  inserted->right = NULL;
  inserted->value = value;

  while(tmp != NULL){// Hledání uzlu kam budeme vkládat
    previous = tmp;// Posun
    if(key > tmp->key){// Hledání v levém podstromu
      tmp = tmp->right;
    }else if(key < tmp->key){// Hledání v pravém podstromu
      tmp = tmp->left;
    }else {
      tmp->value = value;
      free(inserted);
      return;
    }
  }
  if(previous == NULL){// Máme prázdný strom --> nový uzel bude kořenem
    previous = inserted;
    *tree = previous;
  } 
  if(key < previous->key){
    previous->left = inserted;//Vložený je levý list
  }else if(key > previous->key){
    previous->right = inserted;//Vložený je pravý list
  }
}

/*
 * Pomocná funkcia ktorá nahradí uzol najpravejším potomkom.
 *
 * Kľúč a hodnota uzlu target budú nahradené kľúčom a hodnotou najpravejšieho
 * uzlu podstromu tree. Najpravejší potomok bude odstránený. Funkcia korektne
 * uvoľní všetky alokované zdroje odstráneného uzlu.
 *
 * Funkcia predpokladá že hodnota tree nie je NULL.
 *
 * Táto pomocná funkcia bude využitá pri implementácii funkcie bst_delete.
 *
 * Funkciu implementujte iteratívne bez použitia vlastných pomocných funkcií.
 */
void bst_replace_by_rightmost(bst_node_t *target, bst_node_t **tree) {
}

/*
 * Odstránenie uzlu v strome.
 *
 * Pokiaľ uzol so zadaným kľúčom neexistuje, funkcia nič nerobí.
 * Pokiaľ má odstránený uzol jeden podstrom, zdedí ho otec odstráneného uzla.
 * Pokiaľ má odstránený uzol oba podstromy, je nahradený najpravejším uzlom
 * ľavého podstromu. Najpravejší uzol nemusí byť listom!
 * Funkcia korektne uvoľní všetky alokované zdroje odstráneného uzlu.
 *
 * Funkciu implementujte iteratívne pomocou bst_replace_by_rightmost a bez
 * použitia vlastných pomocných funkcií.
 */
void bst_delete(bst_node_t **tree, char key) {
}

/*
 * Zrušenie celého stromu.
 *
 * Po zrušení sa celý strom bude nachádzať v rovnakom stave ako po
 * inicializácii. Funkcia korektne uvoľní všetky alokované zdroje rušených
 * uzlov.
 *
 * Funkciu implementujte iteratívne pomocou zásobníku uzlov a bez použitia
 * vlastných pomocných funkcií.
 */
void bst_dispose(bst_node_t **tree) {
  
  stack_bst_t stack;// Vytvoreni zasobniku
  stack_bst_init(&stack);
  stack_bst_push(&stack, *tree); // pushuti korene
  bst_node_t *tmp = *tree;

  while(!stack_bst_empty(&stack)){// dokud nemam prazdny zasobnik
  tmp = stack_bst_pop(&stack); // ziskani uzlu z vrcholu zasobniku

  if(tmp->left != NULL){ // strom ma levy podstrom
    //stack_bst_push(&stack, tmp->left);//TODO SEGFAULTUJE:))))
  }  
  if(tmp->right != NULL){// strom ma pravy podstrom
    //stack_bst_push(&stack, tmp->right);//TODO SEGFAULTUJE:))))
  }
  free(tmp);
  }
  *tree = NULL; // RESET stromu
}

/*
 * Pomocná funkcia pre iteratívny preorder.
 *
 * Prechádza po ľavej vetve k najľavejšiemu uzlu podstromu.
 * Nad spracovanými uzlami zavola bst_print_node a uloží ich do zásobníku uzlov.
 *
 * Funkciu implementujte iteratívne pomocou zásobníku uzlov a bez použitia
 * vlastných pomocných funkcií.
 */
void bst_leftmost_preorder(bst_node_t *tree, stack_bst_t *to_visit) {
    while(tree != NULL){// prochazeni dokud neni prazdno
    bst_print_node(tree);// vypsani uzlu
    stack_bst_push(to_visit, tree);//ulozeni uzlu na stack
    tree = tree->left;//posun
  }
}

/*
 * Preorder prechod stromom.
 *
 * Pre aktuálne spracovávaný uzol nad ním zavolajte funkciu bst_print_node.
 *
 * Funkciu implementujte iteratívne pomocou funkcie bst_leftmost_preorder a
 * zásobníku uzlov bez použitia vlastných pomocných funkcií.
 */
void bst_preorder(bst_node_t *tree) {
  stack_bst_t stack;// Vytvoreni zasobniku
  stack_bst_init(&stack);
  bst_leftmost_preorder(tree, &stack);
  while(!stack_bst_empty(&stack)){// dokud nemam prazdny zasobnik
    tree = stack_bst_pop(&stack);// ziskame vrsek zasobniku
    bst_leftmost_preorder(tree->right, &stack); // najdeme nejlevejsi uzel v podstromu
  }
}

/*
 * Pomocná funkcia pre iteratívny inorder.
 *
 * Prechádza po ľavej vetve k najľavejšiemu uzlu podstromu a ukladá uzly do
 * zásobníku uzlov.
 *
 * Funkciu implementujte iteratívne pomocou zásobníku uzlov a bez použitia
 * vlastných pomocných funkcií.
 */
void bst_leftmost_inorder(bst_node_t *tree, stack_bst_t *to_visit) {
  while(tree != NULL){
    stack_bst_push(to_visit, tree);
    tree = tree->left;
  }
}

/*
 * Inorder prechod stromom.
 *
 * Pre aktuálne spracovávaný uzol nad ním zavolajte funkciu bst_print_node.
 *
 * Funkciu implementujte iteratívne pomocou funkcie bst_leftmost_inorder a
 * zásobníku uzlov bez použitia vlastných pomocných funkcií.
 */
void bst_inorder(bst_node_t *tree) {
  stack_bst_t stack;// Vytvoreni zasobniku
  stack_bst_init(&stack);

  bst_leftmost_inorder(tree, &stack);
  while (!stack_bst_empty(&stack)){
    tree = stack_bst_pop(&stack);//nacteni prvku
    bst_print_node(tree);
    if(tree->right != NULL){//pokud pravy podstrom neni prazdny
      bst_leftmost_inorder(tree->right, &stack);
    }
  }
}

/*
 * Pomocná funkcia pre iteratívny postorder.
 *
 * Prechádza po ľavej vetve k najľavejšiemu uzlu podstromu a ukladá uzly do
 * zásobníku uzlov. Do zásobníku bool hodnôt ukladá informáciu že uzol
 * bol navštívený prvý krát.
 *
 * Funkciu implementujte iteratívne pomocou zásobníkov uzlov a bool hodnôt a bez použitia
 * vlastných pomocných funkcií.
 */
void bst_leftmost_postorder(bst_node_t *tree, stack_bst_t *to_visit,
stack_bool_t *first_visit) {
    while(tree != NULL){
    stack_bst_push(to_visit, tree); //ulozeni ukazatele
    stack_bool_push(first_visit, true); //node jiz navstiven
    tree = tree->left; // posun
    }
}

/*
 * Postorder prechod stromom.
 *
 * Pre aktuálne spracovávaný uzol nad ním zavolajte funkciu bst_print_node.
 *
 * Funkciu implementujte iteratívne pomocou funkcie bst_leftmost_postorder a
 * zásobníkov uzlov a bool hodnôt bez použitia vlastných pomocných funkcií.
 */
void bst_postorder(bst_node_t *tree) {
  stack_bst_t stack;// Vytvoreni zasobniku
  stack_bst_init(&stack);
  stack_bool_t stackBool;// Vytvoreni zasobniku
  stack_bool_init(&stackBool);

  bst_leftmost_postorder(tree, &stack, &stackBool);

  while(!stack_bst_empty(&stack)){
    tree = stack_bst_pop(&stack); // nacteni uzlu ze zasobniku
    stack_bst_push(&stack, tree); // vraceni uzlu na zasobnik

    if(stack_bool_pop(&stackBool)){ //jdeme zleva/zprava?
      stack_bool_push(&stackBool, false);// ocekavame jeste neco
      bst_leftmost_postorder(tree->right, &stack, &stackBool);
    }else{
      stack_bst_pop(&stack); 
      bst_print_node(tree); // vypsani uzlu
    }
  }
}
