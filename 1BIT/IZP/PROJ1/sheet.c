/*****************************
    1BIT - IZP - PROJEKT 1 - Práce s textem
    AUTOR: Ladislav Vašina
    FIT LOGIN: xvasin11
    ROK: 2020
******************************/

#include <stdio.h>
#include <stdbool.h>
#include <ctype.h>
#include <math.h>
#include <string.h>
#include <stdlib.h>
#include <errno.h>
#include <limits.h>
#include <stdlib.h>

#define MAX_ROW_LENGTH 10242 // 10KiB = 10240B + \n + \0
#define MAX_ARG_CELL_LENGTH 100


int arow(int cellCount, char outputDelim);
int insNum(int argPos, char *argv[]);
int drows(int argPos, char *argv[], int rowCount);
int roundNo(double num);
int floorNo(double num);

int main(int argc, char *argv[]) {

    char buffer[MAX_ROW_LENGTH];
    char *delim = " ";
    char outputDelim;
    if (argc == 1) {
        fprintf(stderr, "NO ARGUMENTS ENTERED!\n");
        return 1;
    } else {
        if (strcmp(argv[1], "-d") == 0) {
            if (argv[2] == NULL) {
                fprintf(stderr, "INCORRECT DELIMITER SETTING!\n");
                return 1;
            }
            if (argv[3] == NULL) {
                fprintf(stderr, "NO ARGUMENTS ENTERED!\n");
                return 1;
            }
            delim = argv[2];
            outputDelim = argv[2][0];
        }else{
            outputDelim = ' '; //Defaultní delim nastaven na mezeru
        }

        for (int i = 0; i < argc; i++) {
            if (strlen(argv[i]) > MAX_ARG_CELL_LENGTH) {
                fprintf(stderr, "MAXIMUM ARGUMENT SIZE EXCEEDED!\n"); // MAXIMUM ARGUMENT SIZE = 100
                return 1;
            }
        }
    }

//!!!Každé spuštění programu může obsahovat nejvíce jeden příkaz pro zpracování dat.
    int rowCount = 0;
    int cellCount = 0;

    int argPos = 3;
    if (strcmp(argv[1], "-d")) {
        argPos = 1;
    }

    while (fgets(buffer, MAX_ROW_LENGTH, stdin) != NULL) { //Načítá po řádcích ze stdin dokud nenarazí řádek bez obsahu
        rowCount++;

//Získávání počtu buňek
        char *str = buffer;
        char *sep = delim;
        unsigned int cnt = 0;
        int colFlag = 0;
        int acolFlag = 0;

        do {
            str = strpbrk(str, sep); //hledání delimitru
            if (str) str += strspn(str, sep); //přeskočení delimitru
            cnt++; //inkrementace počtu buněk
        } while (str && *str);

        if (rowCount == 1) {
            cellCount = cnt;
        }
//!PRIKAZY PRO UPRAVU TABULKY
        //irow R - vloží řádek tabulky před řádek R > 0 (insert-row).
        if (strcmp(argv[argPos], "irow") == 0) {
            if (insNum(argPos, argv) == rowCount) {
                for (int i = 0; i < cellCount - 1; i++) putchar(outputDelim);
                printf("\n");
            }
        //drow R - odstraní řádek číslo R > 0 (delete-row).
        } else if (strcmp(argv[argPos], "drow") == 0) {
            if (insNum(argPos, argv) == rowCount) {//Pokud se má zrovna vypisovat řádek shodný se zadaným řádkem -->
                continue;                          //--> Tak se nic nevypíše
            }
        //drows N M - odstraní řádky N až M (N <= M). V případě N=M se příkaz chová stejně jako drow N.
        } else if (strcmp(argv[argPos], "drows") == 0) {
            if (drows(argPos, argv, rowCount) == true) {//Fce drows vrací true pokud je daný řádek v rozmezí N až M -->
                continue;                               //--> Nevypisuje nic
            }
        //icol C - vloží prázdný sloupec před sloupec daný číslem C.
        } else if (strcmp(argv[argPos], "icol") == 0) {
            unsigned int insertedNum = insNum(argPos, argv);
            colFlag = 1;
            char cells[MAX_ARG_CELL_LENGTH][MAX_ARG_CELL_LENGTH];
            unsigned int indexCtr = 0;
            unsigned int cellIndex = 0;
            unsigned int totalCells = 0;
            //Rozprasování buněk do pole
            for (indexCtr = 0; indexCtr <= strlen(buffer); indexCtr++){
                if (buffer[indexCtr] == *delim || buffer[indexCtr] == '\n'){
                    cells[totalCells][cellIndex] = '\0';
                    totalCells++;
                    cellIndex = 0;
                }else{
                    cells[totalCells][cellIndex] = buffer[indexCtr];
                    cellIndex++;
                }
            }
            if (!strcmp(delim, " ")){

            }
            else if (insertedNum > totalCells){ //číslo sloupce u fce icol je větší než počet sloupců
                fprintf(stderr, "INVALID COL IDENTIFICATOR!");
                return 1;
            }

            for(indexCtr = 0; indexCtr < totalCells; indexCtr++){
                unsigned int isOne = 0;
                if (insertedNum == 1){
                    printf("%c", outputDelim);
                    isOne = 1;
                }
                printf("%s", cells[indexCtr]);

                if (indexCtr == insertedNum-2){
                    printf("%c", outputDelim);
                }
               if (isOne != 1){
               if (indexCtr != totalCells-1){
                   printf("%c", outputDelim);
                }
               }
            }printf("\n");
        }
            //acol - přidá prázdný sloupec za poslední sloupec.
        else if (strcmp(argv[argPos], "acol") == 0) {
            int rowLength = strlen(buffer);
            buffer[rowLength-1] = outputDelim;//Vymění poslední znak řádku \n za delim -> řádky se vypisují za sebe ->
            acolFlag = 1;                     //-->acolFlag řiká, aby se jednoduše po každém řádku vypsal znovu nový řádek. viz řádek 623
        }
            //dcol C - odstraní sloupec číslo C.
        else if (strcmp(argv[argPos], "dcol") == 0) {
            unsigned int insertedNum = insNum(argPos, argv);
            colFlag = 1;
            char cells[MAX_ARG_CELL_LENGTH][MAX_ARG_CELL_LENGTH];
            unsigned int indexCtr = 0;
            unsigned int cellIndex = 0;
            unsigned int totalCells = 0;
            //Rozprasování buněk do pole
            for (indexCtr = 0; indexCtr <= strlen(buffer); indexCtr++){
                if (buffer[indexCtr] == *delim || buffer[indexCtr] == '\n'){
                    cells[totalCells][cellIndex] = '\0';
                    totalCells++;
                    cellIndex = 0;
                }else{
                    cells[totalCells][cellIndex] = buffer[indexCtr];
                    cellIndex++;
                }
            }
            if (!strcmp(delim, " ")){

            }
            else if (insertedNum > totalCells){ //číslo sloupce u fce dcol je větší než počet sloupců
                fprintf(stderr, "INVALID COL IDENTIFICATOR!");
                return 1;
            }
            unsigned int cellsPrinted = 0;
            for(indexCtr = 0; indexCtr < totalCells; indexCtr++){
                if (insertedNum - 1 == indexCtr){} //Pokud se je zrovna vypisovaný sloupec shodný s požadovaným sloupcem pro odstranění, tak se nic nevypíše
                else{
                printf("%s", cells[indexCtr]);
                cellsPrinted++;
                if (cellsPrinted < totalCells - 1){
                printf("%c", outputDelim);
                }
            }
            }printf("\n");
        }
            //dcols N M - odstraní sloupce N až M (N <= M). V případě N=M se příkaz chová stejně jako dcol N.
        else if (strcmp(argv[argPos], "dcols") == 0) {
            unsigned int N = insNum(argPos, argv);
            unsigned int M = insNum(argPos + 1, argv);
            if (N > M){
                fprintf(stderr, "N is smaller then M!");
                return 1;
            }
            colFlag = 1;
            char cells[MAX_ARG_CELL_LENGTH][MAX_ARG_CELL_LENGTH];
            unsigned int indexCtr = 0;
            unsigned int cellIndex = 0;
            unsigned int totalCells = 0;
            //Rozprasování buněk do pole
            for (indexCtr = 0; indexCtr <= strlen(buffer); indexCtr++){
                if (buffer[indexCtr] == *delim || buffer[indexCtr] == '\n'){
                    cells[totalCells][cellIndex] = '\0';
                    totalCells++;
                    cellIndex = 0;
                }else{
                    cells[totalCells][cellIndex] = buffer[indexCtr];
                    cellIndex++;
                }
            }
            if (!strcmp(delim, " ")){

            }
            else if (N <= M && M > totalCells){ //N je menší než M a číslo sloupce M u fce dcols je větší než počet sloupců
                fprintf(stderr, "INVALID COL IDENTIFICATOR!");
                return 1;
            }
            unsigned int cellsPrinted = 0;
            unsigned int deletedCols = M - N + 1;
            for(indexCtr = 0; indexCtr < totalCells; indexCtr++){
                if (N-1 <= indexCtr && M-1 >= indexCtr){} // Pokud je zrovna na řadě sloupec který je v rozsahu N,M, tak se nevypíše
                else{
                    printf("%s", cells[indexCtr]);
                    cellsPrinted++;
                    if (deletedCols != totalCells-1){
                        if (cellsPrinted != totalCells-deletedCols){
                        printf("%c", outputDelim);}
                    }
                }
            }printf("\n");

        } else{} /* default: */

//!Příkazy pro zpracování dat
        //cset C STR - do buňky ve sloupci C bude nastaven řetězec STR.
        if (strcmp(argv[argPos], "cset") == 0) {
            unsigned int insertedNum = insNum(argPos, argv);
            colFlag = 1;
            char cells[MAX_ARG_CELL_LENGTH][MAX_ARG_CELL_LENGTH];
            unsigned int indexCtr = 0;
            unsigned int cellIndex = 0;
            unsigned int totalCells = 0;
            //Rozprasování buněk do pole
            for (indexCtr = 0; indexCtr <= strlen(buffer); indexCtr++){
                if (buffer[indexCtr] == *delim || buffer[indexCtr] == '\n'){
                    cells[totalCells][cellIndex] = '\0';
                    totalCells++;
                    cellIndex = 0;
                }else{
                    cells[totalCells][cellIndex] = buffer[indexCtr];
                    cellIndex++;
                }
            }
            if (!strcmp(delim, " ")){

            }
            else if (insertedNum > totalCells){ //číslo sloupce u fce icol je větší než počet sloupců
                fprintf(stderr, "INVALID COL IDENTIFICATOR!");
                return 1;
            }

            for(indexCtr = 0; indexCtr < totalCells; indexCtr++){

                if (argv[argPos+2] == NULL){
                    fprintf(stderr, "NO STR ENTERED!");
                    return 1;
                }
                else if (indexCtr == insertedNum-1){//Do vybraného sloupce nastaví hodnotu STR
                    strcpy(cells[indexCtr], argv[argPos+2]);
                }

                printf("%s", cells[indexCtr]);
                    if (indexCtr != totalCells-1){
                        printf("%c", outputDelim);
                    }

            }printf("\n");
        }
        //tolower C - řetězec ve sloupci C bude převeden na malá písmena.
        else if (strcmp(argv[argPos], "tolower") == 0){
            unsigned int insertedNum = insNum(argPos, argv);
            colFlag = 1;
            char cells[MAX_ARG_CELL_LENGTH][MAX_ARG_CELL_LENGTH];
            unsigned int indexCtr = 0;
            unsigned int cellIndex = 0;
            unsigned int totalCells = 0;
            //Rozprasování buněk do pole
            for (indexCtr = 0; indexCtr <= strlen(buffer); indexCtr++){
                if (buffer[indexCtr] == *delim || buffer[indexCtr] == '\n'){
                    cells[totalCells][cellIndex] = '\0';
                    totalCells++;
                    cellIndex = 0;
                }else{
                    cells[totalCells][cellIndex] = buffer[indexCtr];
                    cellIndex++;
                }
            }
            if (!strcmp(delim, " ")){

            }
            else if (insertedNum > totalCells){ //číslo sloupce u fce icol je větší než počet sloupců
                fprintf(stderr, "INVALID COL IDENTIFICATOR!");
                return 1;
            }

            for(indexCtr = 0; indexCtr < totalCells; indexCtr++){
                if (indexCtr == insertedNum-1){
                    int isAplhaFlag = 0;
                    for (int i = 0; cells[indexCtr][i] != '\0'; i++) {
                        // Kontroluje pokud je znak písmeno
                        if (isalpha(cells[indexCtr][i]) != 0){
                            isAplhaFlag = 1;
                        }
                    }
                    if (isAplhaFlag == 1){

                        int i = 0;
                        while (cells[indexCtr][i] != '\0'){//Prochází každý znak v buňce a nastavujeho na lowerCase
                            printf("%c", tolower(cells[indexCtr][i]));
                            i++;
                        }
                    }else{
                        printf("%s", cells[indexCtr]);
                    }
                }else{
                    printf("%s", cells[indexCtr]);
                }
                if (indexCtr != totalCells-1){
                    printf("%c", outputDelim);
                }
            }printf("\n");
        }
        //toupper C - řetězec ve sloupce C bude převeden na velká písmena.
        else if (strcmp(argv[argPos], "toupper") == 0){
            unsigned int insertedNum = insNum(argPos, argv);
            colFlag = 1;
            char cells[MAX_ARG_CELL_LENGTH][MAX_ARG_CELL_LENGTH];
            unsigned int indexCtr = 0;
            unsigned int cellIndex = 0;
            unsigned int totalCells = 0;
            //Rozprasování buněk do pole
            for (indexCtr = 0; indexCtr <= strlen(buffer); indexCtr++){
                if (buffer[indexCtr] == *delim || buffer[indexCtr] == '\n'){
                    cells[totalCells][cellIndex] = '\0';
                    totalCells++;
                    cellIndex = 0;
                }else{
                    cells[totalCells][cellIndex] = buffer[indexCtr];
                    cellIndex++;
                }
            }
            if (!strcmp(delim, " ")){

            }
            else if (insertedNum > totalCells){ //číslo sloupce u fce icol je větší než počet sloupců
                fprintf(stderr, "INVALID COL IDENTIFICATOR!");
                return 1;
            }

            for(indexCtr = 0; indexCtr < totalCells; indexCtr++){
                if (indexCtr == insertedNum-1){
                    int isAplhaFlag = 0;
                    for (int i = 0; cells[indexCtr][i] != '\0'; i++) {
                        // Kontroluje zda je znak písmeno
                        if (isalpha(cells[indexCtr][i]) != 0){
                            isAplhaFlag = 1;
                        }
                    }
                    if (isAplhaFlag == 1){

                        int i = 0;
                        while (cells[indexCtr][i] != '\0'){//Prochází každý znak v buňce a nastavujeho na upperCase
                            printf("%c", toupper(cells[indexCtr][i]));
                            i++;
                        }
                    }else{
                        printf("%s", cells[indexCtr]);
                    }
                }else{
                    printf("%s", cells[indexCtr]);
                }
                if (indexCtr != totalCells-1){
                    printf("%c", outputDelim);
                }
            }printf("\n");
        }
        //round C - ve sloupci C zaokrouhlí číslo na celé číslo.
        else if (strcmp(argv[argPos], "round") == 0){
            unsigned int insertedNum = insNum(argPos, argv);
            colFlag = 1;
            char cells[MAX_ARG_CELL_LENGTH][MAX_ARG_CELL_LENGTH];
            unsigned int indexCtr = 0;
            unsigned int cellIndex = 0;
            unsigned int totalCells = 0;
            //Rozprasování buněk do pole
            for (indexCtr = 0; indexCtr <= strlen(buffer); indexCtr++){
                if (buffer[indexCtr] == *delim || buffer[indexCtr] == '\n'){
                    cells[totalCells][cellIndex] = '\0';
                    totalCells++;
                    cellIndex = 0;
                }else{
                    cells[totalCells][cellIndex] = buffer[indexCtr];
                    cellIndex++;
                }
            }
            if (!strcmp(delim, " ")){

            }
            else if (insertedNum > totalCells){ //číslo sloupce u fce icol je větší než počet sloupců
                fprintf(stderr, "INVALID COL IDENTIFICATOR!");
                return 1;
            }

            for(indexCtr = 0; indexCtr < totalCells; indexCtr++){
                if (indexCtr == insertedNum-1){
                    int isAplhaFlag = 0;
                    for (int i = 0; cells[indexCtr][i] != '\0'; i++) {
                        // Kontrola pokud je písmeno v obsahu buňky -> nelze převést na číslo
                        if (isalpha(cells[indexCtr][i]) != 0){
                            isAplhaFlag = 1;
                        }
                    }
                    if (isAplhaFlag != 1){
                    char *end;
                    double convertedToDouble = strtod(cells[indexCtr], &end);
                    printf("%d", roundNo(convertedToDouble));
                    }else{
                        printf("%s", cells[indexCtr]);
                    }
                }else{
                printf("%s", cells[indexCtr]);
            }
                    if (indexCtr != totalCells-1){
                        printf("%c", outputDelim);
                    }
            }printf("\n");
        }
        //int C - odstraní desetinnou část čísla ve sloupci C.
        else if (strcmp(argv[argPos], "int") == 0){
            unsigned int insertedNum = insNum(argPos, argv);
            colFlag = 1;
            char cells[MAX_ARG_CELL_LENGTH][MAX_ARG_CELL_LENGTH];
            unsigned int indexCtr = 0;
            unsigned int cellIndex = 0;
            unsigned int totalCells = 0;
            //Rozprasování buněk do pole
            for (indexCtr = 0; indexCtr <= strlen(buffer); indexCtr++){
                if (buffer[indexCtr] == *delim || buffer[indexCtr] == '\n'){
                    cells[totalCells][cellIndex] = '\0';
                    totalCells++;
                    cellIndex = 0;
                }else{
                    cells[totalCells][cellIndex] = buffer[indexCtr];
                    cellIndex++;
                }
            }
            if (!strcmp(delim, " ")){

            }
            else if (insertedNum > totalCells){ //číslo sloupce u fce icol je větší než počet sloupců
                fprintf(stderr, "INVALID COL IDENTIFICATOR!");
                return 1;
            }

            for(indexCtr = 0; indexCtr < totalCells; indexCtr++){
                if (indexCtr == insertedNum-1){
                    int isAplhaFlag = 0;
                    for (int i = 0; cells[indexCtr][i] != '\0'; i++) {
                        // Kontrola pohud je písmeno v obsahu buňky -> nelze převést na číslo -> nelze odstranit des. místo
                        if (isalpha(cells[indexCtr][i]) != 0){
                            isAplhaFlag = 1;
                        }
                    }
                    if (isAplhaFlag != 1){

                    int i = 0;
                    while (cells[indexCtr][i] != '.'){ // Vypisuje dokud nenarazí na des. tečku
                        printf("%c", cells[indexCtr][i]);
                        i++;
                    }
                    }else{
                        printf("%s", cells[indexCtr]);
                    }
                }else{
                    printf("%s", cells[indexCtr]);
                }
                if (indexCtr != totalCells-1){
                    printf("%c", outputDelim);
                }
            }printf("\n");
        }
        //copy N M - přepíše obsah buněk ve sloupci M hodnotami ze sloupce N.
        else if (strcmp(argv[argPos], "copy") == 0){
            unsigned int N = insNum(argPos, argv);
            unsigned int M = insNum(argPos+1, argv);
            colFlag = 1;
            char cells[MAX_ARG_CELL_LENGTH][MAX_ARG_CELL_LENGTH];
            unsigned int indexCtr = 0;
            unsigned int cellIndex = 0;
            unsigned int totalCells = 0;
            //Rozprasování buněk do pole
            for (indexCtr = 0; indexCtr <= strlen(buffer); indexCtr++){
                if (buffer[indexCtr] == *delim || buffer[indexCtr] == '\n'){
                    cells[totalCells][cellIndex] = '\0';
                    totalCells++;
                    cellIndex = 0;
                }else{
                    cells[totalCells][cellIndex] = buffer[indexCtr];
                    cellIndex++;
                }
            }
            if (!strcmp(delim, " ")){

            }
            else if (N > totalCells || M > totalCells){
                fprintf(stderr, "INVALID COL IDENTIFICATOR!");
                return 1;
            }

            for(indexCtr = 0; indexCtr < totalCells; indexCtr++){

                strcpy(cells[M-1], cells[N-1]);

                printf("%s", cells[indexCtr]);
                if (indexCtr != totalCells-1){
                    printf("%c", outputDelim);
                }

            }printf("\n");
        }
        //swap N M - zamění hodnoty buněk ve sloupcích N a M.
        else if (strcmp(argv[argPos], "swap") == 0){
                unsigned int N = insNum(argPos, argv);
                unsigned int M = insNum(argPos+1, argv);
                colFlag = 1;
                char cells[MAX_ARG_CELL_LENGTH][MAX_ARG_CELL_LENGTH];
                unsigned int indexCtr = 0;
                unsigned int cellIndex = 0;
                unsigned int totalCells = 0;
                //Rozprasování buněk do pole
                for (indexCtr = 0; indexCtr <= strlen(buffer); indexCtr++){
                    if (buffer[indexCtr] == *delim || buffer[indexCtr] == '\n'){
                        cells[totalCells][cellIndex] = '\0';
                        totalCells++;
                        cellIndex = 0;
                    }else{
                        cells[totalCells][cellIndex] = buffer[indexCtr];
                        cellIndex++;
                    }
                }
                if (!strcmp(delim, " ")){

                }
                else if (N > totalCells || M > totalCells){
                    fprintf(stderr, "INVALID COL IDENTIFICATOR!");
                    return 1;
                }

                char helpCell[MAX_ARG_CELL_LENGTH]; //Vytvoříme pomocnou buňku pro odložení přesouvané hodnoty
                strcpy(helpCell, cells[N-1]);//Do pomocné buňky uložíme hodnotu buňky N
                strcpy(cells[N-1], cells[M-1]);//Do buňky N uložíme hodnotu buňky M
                strcpy(cells[M-1], helpCell);//Do buňky M nastavíme obsah pomocné buňky

                for(indexCtr = 0; indexCtr < totalCells; indexCtr++){

                    printf("%s", cells[indexCtr]);
                    if (indexCtr != totalCells-1){
                        printf("%c", outputDelim);
                    }
                }printf("\n");
        }
        //move N M - přesune sloupec N před sloupec M.
        else if (strcmp(argv[argPos], "move") == 0){
            unsigned int N = insNum(argPos, argv);
            unsigned int M = insNum(argPos+1, argv);
            colFlag = 1;
            char cells[MAX_ARG_CELL_LENGTH][MAX_ARG_CELL_LENGTH];
            unsigned int indexCtr = 0;
            unsigned int cellIndex = 0;
            unsigned int totalCells = 0;
            //Rozprasování buněk do pole
            for (indexCtr = 0; indexCtr <= strlen(buffer); indexCtr++){
                if (buffer[indexCtr] == *delim || buffer[indexCtr] == '\n'){
                    cells[totalCells][cellIndex] = '\0';
                    totalCells++;
                    cellIndex = 0;
                }else{
                    cells[totalCells][cellIndex] = buffer[indexCtr];
                    cellIndex++;
                }
            }
            if (!strcmp(delim, " ")){

            }
            else if (N > totalCells || M > totalCells){
                fprintf(stderr, "INVALID COL IDENTIFICATOR!");
                return 1;
            }

            unsigned int cellsPrinted = 0;
            for(indexCtr = 0; indexCtr < totalCells; indexCtr++){
                if (indexCtr == M-1){ // Pokud jsme před sloupcem M -->
                    printf("%s%c",cells[N-1], outputDelim);// --> Vytiskneme sloupec N a za něj delim.
                    cellsPrinted++;
                }
                if (indexCtr != N-1){
                    printf("%s", cells[indexCtr]);// Vytiskneme zbytek
                    cellsPrinted++;
                    if (cellsPrinted != totalCells)// Pokud tiskneme poslední buňku netiskneme delim.
                    printf("%c", outputDelim);
                }
            }printf("\n");
        }

        if (colFlag != 1){
            printf("%s", buffer);
        }
        if (acolFlag == 1){
            printf("\n");
        }
    }
    //arow - přidá nový řádek tabulky na konec tabulky (append-row).
    if (strcmp(argv[argPos], "arow") == 0) {
        arow(cellCount, outputDelim);
    }

    if (rowCount == 0) {
        fprintf(stderr, "EMPTY TABLE ENTERED!\n");
        return 1;
    }
    return 0;
}

int roundNo(double num){
    return num < 0 ? num - 0.5 : num + 0.5;
}
int floorNo(double num){
    return num < 0 ? num - 0.3 : num + 0.3;
}
//Přetypování z char na int
int insNum(int argPos, char *argv[]) {
    char *p;
    int insertedNumber;

    errno = 0;
    if (argv[argPos + 1] == NULL || *argv[argPos + 1] == '0'){
        fprintf(stderr, "INVALID PARAMETER ENTERED!");
        return 1;
    }
    long conv = strtol(argv[argPos + 1], &p, 10);

    //Kontrola pokud je argument fce irow číslo
    if (errno != 0 || *p != '\0' || conv > INT_MAX) {
        fprintf(stderr, "INVALID ROW/COL SELECTOR!\n");
        return 1;
        //No error
    } else {
        insertedNumber = conv;
        return insertedNumber;
    }
}

int arow(int cellCount, char outputDelim) {
    for (int i = 0; i < cellCount - 1; i++) putchar(outputDelim); // Vytiskne delim. (cellCount-1)Krát
    printf("\n");
    return 0;
}

int drows(int argPos, char *argv[], int rowCount) {
    int first = insNum(argPos, argv);
    int second = insNum(argPos + 1, argv);
    if (first > second) {
        fprintf(stderr, "N > M!\n");
        return 1;
    }
    if (first <= rowCount && second >= rowCount) {
        return true;
    } else {
        return false;
    }
}


