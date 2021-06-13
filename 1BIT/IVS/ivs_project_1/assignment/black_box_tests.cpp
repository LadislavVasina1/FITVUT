//======== Copyright (c) 2017, FIT VUT Brno, All rights reserved. ============//
//
// Purpose:     Red-Black Tree - public interface tests
//
// $NoKeywords: $ivs_project_1 $black_box_tests.cpp
// $Author:     LADISLAV VAŠINA <xvasin11@stud.fit.vutbr.cz>
// $Date:       $2017-01-04
//============================================================================//
/**
 * @file black_box_tests.cpp
 * @author LADISLAV VAŠINA
 * 
 * @brief Implementace testu binarniho stromu.
 */

#include <vector>

#include "gtest/gtest.h"

#include "red_black_tree.h"

//============================================================================//
// ** ZDE DOPLNTE TESTY **
//
// Zde doplnte testy Red-Black Tree, testujte nasledujici:
// 1. Verejne rozhrani stromu
//    - InsertNode/DeleteNode a FindNode
//    - Chovani techto metod testuje pro prazdny i neprazdny strom.
// 2. Axiomy (tedy vzdy platne vlastnosti) Red-Black Tree:
//    - Vsechny listove uzly stromu jsou *VZDY* cerne.
//    - Kazdy cerveny uzel muze mit *POUZE* cerne potomky.
//    - Vsechny cesty od kazdeho listoveho uzlu ke koreni stromu obsahuji
//      *STEJNY* pocet cernych uzlu.
//============================================================================//

class EmptyTree : public ::testing::Test
{
protected:
    BinaryTree emptyRedBlackTree;
};

class NonEmptyTree : public ::testing::Test
{
protected:
    virtual void SetUp() {
        int values[] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
        for (auto value : values){
            redBlackTree.InsertNode(value);
        }
    }
    BinaryTree redBlackTree;
};

class TreeAxioms : public ::testing::Test
{
protected:
    virtual void SetUp() {
        int values[] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
        for (auto value : values){
            axiomRedBlackTree.InsertNode(value);
        }
    }
    BinaryTree axiomRedBlackTree;
};

TEST_F(EmptyTree, InsertNode) {
    auto result1 = emptyRedBlackTree.InsertNode(42);
    EXPECT_TRUE(result1.first);
    EXPECT_TRUE(result1.second->key == 42);
    auto result2 = emptyRedBlackTree.InsertNode(42);
    EXPECT_FALSE(result2.first);
    EXPECT_TRUE(result1.second == result2.second);
}
TEST_F(EmptyTree, DeleteNode) {
    EXPECT_FALSE(emptyRedBlackTree.DeleteNode(16));
}
TEST_F(EmptyTree, FindNode) {
    auto result = emptyRedBlackTree.FindNode(7);
    EXPECT_TRUE(result == NULL);
}

TEST_F(NonEmptyTree, InsertNode){
    auto node1 = redBlackTree.InsertNode(11);
    EXPECT_TRUE(node1.first);
    EXPECT_TRUE(node1.second->key == 11);
    auto node2 = redBlackTree.InsertNode(7);
    EXPECT_FALSE(node2.first);
    EXPECT_TRUE(node2.second->key == 7);
}
TEST_F(NonEmptyTree, DeleteNode){
    EXPECT_TRUE(redBlackTree.DeleteNode(5));
    EXPECT_FALSE(redBlackTree.DeleteNode(42));
}
TEST_F(NonEmptyTree, FindNode) {
    auto result1 = redBlackTree.FindNode(3);
    EXPECT_TRUE(result1->key == 3);
    auto result2 = redBlackTree.FindNode(16);
    EXPECT_TRUE(result2 == NULL);
}

TEST_F(TreeAxioms, Axiom1){
   std::vector<Node_t *> leaves;
   axiomRedBlackTree.GetLeafNodes(leaves);
   for (auto node : leaves){
        EXPECT_TRUE(node->color == 1);
   }
}
TEST_F(TreeAxioms, Axiom2){
    std::vector<Node_t *> nodes;
    axiomRedBlackTree.GetAllNodes(nodes);
    for (auto node : nodes){
        if (node->color == 0) {
        EXPECT_TRUE(node->pLeft->color == 1);
        EXPECT_TRUE(node->pRight->color == 1);
        }
    }
}

TEST_F(TreeAxioms, Axiom3){
    std::vector<Node_t *> leaves;
    axiomRedBlackTree.GetLeafNodes(leaves);
    int blackNodeCounter[leaves.size()];
    for (int i = 0; i < leaves.size(); i++){
        auto temp = leaves[i];
        blackNodeCounter[i] = 0;
        while(temp != nullptr){
            if (temp->color == 1) {
                blackNodeCounter[i]++;
            }
            temp = temp->pParent;
        }
    }
    int blacks = blackNodeCounter[0];
    for(int i = 0; i < leaves.size(); i++){
        EXPECT_TRUE(blacks == blackNodeCounter[i]);
    }
}
/*** Konec souboru black_box_tests.cpp ***/
