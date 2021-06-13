//======== Copyright (c) 2021, FIT VUT Brno, All rights reserved. ============//
//
// Purpose:     Test Driven Development - priority queue code
//
// $NoKeywords: $ivs_project_1 $tdd_code.cpp
// $Author:     LADISLAV VAŠINA <xvasin11@stud.fit.vutbr.cz>
// $Date:       $2021-01-04
//============================================================================//
/**
 * @file tdd_code.cpp
 * @author LADISLAV VAŠINA
 * 
 * @brief Implementace metod tridy prioritni fronty.
 */

#include <stdlib.h>
#include <stdio.h>

#include "tdd_code.h"

//============================================================================//
// ** ZDE DOPLNTE IMPLEMENTACI **
//
// Zde doplnte implementaci verejneho rozhrani prioritni fronty (Priority Queue)
// 1. Verejne rozhrani fronty specifikovane v: tdd_code.h (sekce "public:")
//    - Konstruktor (PriorityQueue()), Destruktor (~PriorityQueue())
//    - Metody Insert/Remove/Find a GetHead
//    - Pripadne vase metody definovane v tdd_code.h (sekce "protected:")
//
// Cilem je dosahnout plne funkcni implementace prioritni fronty implementovane
// pomoci tzv. "double-linked list", ktera bude splnovat dodane testy 
// (tdd_tests.cpp).
//============================================================================//

PriorityQueue::PriorityQueue()
{

}

PriorityQueue::~PriorityQueue()
{
m_pHead = nullptr;
}

void PriorityQueue::Insert(int value)
{
    if (m_pHead == nullptr){
    m_pHead = new Element_t{
            .pNext = nullptr,
            .value = value
    };
    return;
    }
    if (m_pHead != nullptr && value > m_pHead->value){
        m_pHead = new Element_t{
                .pNext = m_pHead,
                .value = value
        };
        return;
    }

    auto element = m_pHead;
    while(element->pNext != nullptr && value < element->pNext->value){
        element = element->pNext;
    }

    element->pNext = new Element_t{
            .pNext = element->pNext,
            .value = value
    };
}

bool PriorityQueue::Remove(int value)
{
    //Pokud je queue prazdna
    if (m_pHead == nullptr){
        return false;
    }

    auto temp = m_pHead;
    Element_t *previousNode = nullptr;
    if (temp != nullptr && temp->value == value){
        m_pHead = temp->pNext;
        free(temp);
        return true;
    }
    previousNode = temp;
    while(temp != nullptr && temp->value != value){
        temp = temp->pNext;
    }
    if (temp == nullptr){
        return false;
    }
    previousNode->pNext = temp->pNext;
    free(temp);
}

PriorityQueue::Element_t *PriorityQueue::Find(int value)
{
    Element_t * temp = m_pHead;
    while(temp!= nullptr){
        if(temp->value == value){
            return temp;
        }
        temp = temp->pNext;
    }
    return NULL;
}

size_t PriorityQueue::Length()
{
	int length = 0;
	Element_t *currentNode = m_pHead;
    while (currentNode != nullptr){
        length++;
        currentNode = currentNode->pNext;
    }
    return length;
}

PriorityQueue::Element_t *PriorityQueue::GetHead()
{
    return m_pHead;
}

/*** Konec souboru tdd_code.cpp ***/
