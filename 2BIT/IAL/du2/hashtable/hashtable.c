/*
 * Tabuľka s rozptýlenými položkami
 *
 * S využitím dátových typov zo súboru hashtable.h a pripravených kostier
 * funkcií implementujte tabuľku s rozptýlenými položkami s explicitne
 * zreťazenými synonymami.
 *
 * Pri implementácii uvažujte veľkosť tabuľky HT_SIZE.
 * 
 * Funkce doplnil: Ladislav Vašina, xvasin11 2021
 */

#include "hashtable.h"
#include <stdlib.h>
#include <string.h>

int HT_SIZE = MAX_HT_SIZE;

/*
 * Rozptyľovacia funkcia ktorá pridelí zadanému kľúču index z intervalu
 * <0,HT_SIZE-1>. Ideálna rozptyľovacia funkcia by mala rozprestrieť kľúče
 * rovnomerne po všetkých indexoch. Zamyslite sa nad kvalitou zvolenej funkcie.
 */
int get_hash(char *key) {
  int result = 1;
  int length = strlen(key);
  for (int i = 0; i < length; i++) {
    result += key[i];
  }
  return (result % HT_SIZE);
}

/*
 * Inicializácia tabuľky — zavolá sa pred prvým použitím tabuľky.
 */
void ht_init(ht_table_t *table) {
  if(table != NULL){                
    for(int i = 0; i < HT_SIZE;i++){// Naplnění tabulky NULL hodnotama
      (*table)[i] = NULL;
    }
  }
}

/*
 * Vyhľadanie prvku v tabuľke.
 *
 * V prípade úspechu vráti ukazovateľ na nájdený prvok; v opačnom prípade vráti
 * hodnotu NULL.
 */
ht_item_t *ht_search(ht_table_t *table, char *key) {
  ht_item_t *wanted = (*table)[get_hash(key)]; // Získání položky na daném klíči

  while(wanted != NULL){                       // Procházíme dokonce
    if(strcmp(wanted->key, key) != 0){
      wanted = wanted->next;
    }else if(strcmp(wanted->key, key) == 0){   //Pokud máme shodu klíčů vracíme 
      return wanted;
    }
  }
  return NULL;
}

/*
 * Vloženie nového prvku do tabuľky.
 *
 * Pokiaľ prvok s daným kľúčom už v tabuľke existuje, nahraďte jeho hodnotu.
 *
 * Pri implementácii využite funkciu ht_search. Pri vkladaní prvku do zoznamu
 * synonym zvoľte najefektívnejšiu možnosť a vložte prvok na začiatok zoznamu.
 */
void ht_insert(ht_table_t *table, char *key, float value) {
  ht_item_t *currentItem = NULL;
  currentItem = ht_search(table, key);

  if(currentItem != NULL){ // Pokud prvek s daným klíčem již existuje --> nahradíme jeho data
    currentItem->value = value;
    return;
  }else{ //Prvek nenalezen v tabulce
    ht_item_t *addedItem = (ht_item_t *) malloc(sizeof(ht_item_t)); 
      if(addedItem == NULL){
        return; // Nepodařená alokace
      }
    addedItem->key = key;
    addedItem->value = value;
    
    
    if((*table)[get_hash(key)]!= NULL){ 
      addedItem->next = (*table)[get_hash(key)];// Prvek již exituje --> odkazujeme na něj
    }else if((*table)[get_hash(key)] == NULL){
      addedItem->next = NULL;// Neodkazujeme na další prvek
    }
    (*table)[get_hash(key)] = addedItem;
}
    

}

/*
 * Získanie hodnoty z tabuľky.
 *
 * V prípade úspechu vráti funkcia ukazovateľ na hodnotu prvku, v opačnom
 * prípade hodnotu NULL.
 *
 * Pri implementácii využite funkciu ht_search.
 */
float *ht_get(ht_table_t *table, char *key) {
  ht_item_t *found = ht_search(table, key);
  if(found == NULL){
    return NULL;
  }else{
    return &found->value;
  }
}

/*
 * Zmazanie prvku z tabuľky.
 *
 * Funkcia korektne uvoľní všetky alokované zdroje priradené k danému prvku.
 * Pokiaľ prvok neexistuje, nerobte nič.
 *
 * Pri implementácii NEVYUŽÍVAJTE funkciu ht_search.
 */
void ht_delete(ht_table_t *table, char *key) {
  ht_item_t *previousItem = NULL;
  ht_item_t *currentItem = (*table)[get_hash(key)];
  
  while(strcmp(currentItem->key, key) != 0){// Pokud jsme nenalezli požadovanou položku 
    previousItem = currentItem;
    currentItem = currentItem->next; // Posouváme ukazatele
  }
  if(previousItem == NULL){ // Pokud hledaná položka byla první 
    (*table)[(get_hash(key))] = currentItem->next; // Uděláme posun
  }else if(previousItem != NULL){// Pokud mazaná položka nebyla první
    previousItem->next = currentItem->next;// Ukazatel předchozí dáme na následující
  }
  free(currentItem);// Uvolníme položku z paměti
}

/*
 * Zmazanie všetkých prvkov z tabuľky.
 *
 * Funkcia korektne uvoľní všetky alokované zdroje a uvedie tabuľku do stavu po
 * inicializácii.
 */
void ht_delete_all(ht_table_t *table) {
  for(int i = 0; i < HT_SIZE; i++){  // Projití všech položek HT
    ht_item_t *currentItem = (*table)[i];
    ht_item_t *nextItem;

   while (currentItem != NULL){// Projití všech položek daného hashe
      nextItem = currentItem->next; // Posun
      free(currentItem); // Uvolnění paměti
      currentItem = nextItem;// Posun
    }
  }
  for(int i = 0; i < HT_SIZE;i++){// Naplnění tabulky NULL hodnotama
    (*table)[i] = NULL;
  }
}