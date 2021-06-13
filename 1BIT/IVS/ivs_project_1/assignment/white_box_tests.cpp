//======== Copyright (c) 2021, FIT VUT Brno, All rights reserved. ============//
//
// Purpose:     White Box - Tests suite
//
// $NoKeywords: $ivs_project_1 $white_box_code.cpp
// $Author:     LADISLAV VAŠINA <xvasin11@stud.fit.vutbr.cz>
// $Date:       $2021-01-04
//============================================================================//
/**
 * @file white_box_tests.cpp
 * @author LADISLAV VAŠINA
 * 
 * @brief Implementace testu prace s maticemi.
 */

#include "gtest/gtest.h"
#include "white_box_code.h"

//============================================================================//
// ** ZDE DOPLNTE TESTY **
//
// Zde doplnte testy operaci nad maticemi. Cilem testovani je:
// 1. Dosahnout maximalniho pokryti kodu (white_box_code.cpp) testy.
// 2. Overit spravne chovani operaci nad maticemi v zavislosti na rozmerech 
//    matic.
//============================================================================//



class Matrix1x1 : public ::testing::Test {
    protected:
    Matrix m{};
};

TEST(MatrixTests, MatrixConstr) {
    Matrix x1{};
    EXPECT_EQ(x1.get(0, 0), 0);
    Matrix x2{3,3};
    EXPECT_ANY_THROW(Matrix(0, 42));
    EXPECT_ANY_THROW(Matrix(42, 0));
    Matrix x3{2, 2};
    EXPECT_ANY_THROW(x3.get(7,16));
}
TEST(MatrixTests, MatrixSetter){
    Matrix mat1{4,4};
    EXPECT_EQ(mat1.set(1, 1, 7),true);
    Matrix mat2{2,2};
    EXPECT_EQ(mat2.set({{1,1},{1,1}}), true);
    EXPECT_FALSE(mat2.set(16, 7, 42));
    EXPECT_FALSE(mat2.set({{1,1},{1,1},{1,1}}));
    EXPECT_FALSE(mat2.set({{1,1,1},{1,1,1},{1,1,1}}));
}
TEST(MatrixTests, Equal){
    Matrix mat21{2,2};
    Matrix mat22{2,2};
    Matrix mat31{3,3};
    EXPECT_TRUE(mat21 == mat22);
    mat21.set(0, 0, 5);
    mat22.set(0, 0, 7);
    EXPECT_FALSE(mat21 == mat22);
    EXPECT_ANY_THROW(mat21 == mat31);
}
TEST(MatrixTests, Addition){
    Matrix x1{};
    Matrix x2{};
    x2.set(0, 0, 5);
    Matrix result = x1 + x2;
    EXPECT_EQ(result.get(0, 0), 5);

    Matrix mat21{2,2};
    Matrix mat31{3,3};
    EXPECT_ANY_THROW(Matrix rowsColsBad = mat21 + mat31);
}
TEST(MatrixTests, Multiplication){
    Matrix x1{};
    Matrix x2{};
    x1.set(0, 0, 7);
    x2.set(0, 0, 5);
    Matrix result1 = x1 * x2;
    EXPECT_EQ(result1.get(0, 0), 35);

    Matrix mat21{2,2};
    Matrix mat31{3,3};
    EXPECT_ANY_THROW(Matrix rowsColsBad = mat21 * mat31);

    Matrix mat11{1,1};
    mat11.set(0,0, 2);
    double scalar = 7;
    mat11 = mat11 * scalar;
    EXPECT_EQ(mat11.get(0,0), 14);
}
TEST(MatrixTests, Cramer){
    Matrix m1x1{1,1};
    m1x1.set(0, 0, 1);
    std::vector<double> res1 = {{10}};
    EXPECT_EQ(m1x1.solveEquation({{10}}), res1);
    EXPECT_ANY_THROW(m1x1.solveEquation({{10},{30}}));

    Matrix m2x2{2,2};
    m2x2.set(0, 0, 1);
    m2x2.set(0, 1, 2);
    m2x2.set(1, 0, 3);
    m2x2.set(1, 1, 4);
    std::vector<double> res2 = {{10, 0}};
    EXPECT_EQ(m2x2.solveEquation({{10},{30}}), res2);

    Matrix m3x3{3,3};
    m3x3.set(0, 0, 1);
    m3x3.set(0, 1, 2);
    m3x3.set(0, 2, 3);
    m3x3.set(1, 0, 4);
    m3x3.set(1, 1, 5);
    m3x3.set(1, 2, 6);
    m3x3.set(2, 0, 7);
    m3x3.set(2, 1, 8);
    m3x3.set(2, 2, 9);
    EXPECT_ANY_THROW(m3x3.solveEquation({{10},{30},{50}}));

    Matrix m2x1{2,1};
    m2x1.set(0, 0, 1);
    m2x1.set(1,0,2);
    EXPECT_ANY_THROW(m2x1.solveEquation({{10}}));

    Matrix singular{2, 2};
    m2x2.set(0, 0, 1);
    m2x2.set(0, 1, 2);
    m2x2.set(1, 0, 2);
    m2x2.set(1, 1, 4);
    EXPECT_ANY_THROW(singular.solveEquation({{10},{30}}));

    Matrix m4x4{4, 4};
    EXPECT_ANY_THROW(m4x4.solveEquation({{10},{30},{50},{70}}));
}

TEST(MatrixTests, Transpose){
    Matrix m2x3{2,3};
    m2x3.set(0, 0, 1);
    m2x3.set(0, 1, 2);
    m2x3.set(0, 2, 3);
    m2x3.set(1, 0, 4);
    m2x3.set(1, 1, 5);
    m2x3.set(1, 2, 6);
    // 1 2 3
    // 4 5 6
    Matrix mT{3, 2};
    mT.set(0, 0, 1);
    mT.set(0, 1, 4);
    mT.set(1, 0, 2);
    mT.set(1, 1, 5);
    mT.set(2, 0, 3);
    mT.set(2, 1, 6);
    //1 4
    //2 5
    //3 6
    EXPECT_EQ(m2x3.transpose(), mT);
}

TEST(MatrixTests, Inverse){
    Matrix m2x2{2,2};
    m2x2.set(0, 0, 1);
    m2x2.set(0, 1, 2);
    m2x2.set(1, 0, 3);
    m2x2.set(1, 1, 5);
    Matrix inverse1{2,2};
    inverse1.set(0, 0, -5);
    inverse1.set(0, 1, 2);
    inverse1.set(1, 0, 3);
    inverse1.set(1, 1, -1);
    EXPECT_EQ(m2x2.inverse(), inverse1);

    Matrix m3x3{3,3};
    m3x3.set(0, 0, 1);
    m3x3.set(0, 1, 2);
    m3x3.set(0, 2, -3);
    m3x3.set(1, 0, 0);
    m3x3.set(1, 1, 1);
    m3x3.set(1, 2, 2);
    m3x3.set(2, 0, 0);
    m3x3.set(2, 1, 0);
    m3x3.set(2, 2, 1);
    Matrix inverse2{3, 3};
    inverse2.set(0, 0, 1);
    inverse2.set(0, 1, -2);
    inverse2.set(0, 2, 7);
    inverse2.set(1, 0, 0);
    inverse2.set(1, 1, 1);
    inverse2.set(1, 2, -2);
    inverse2.set(2, 0, 0);
    inverse2.set(2, 1, 0);
    inverse2.set(2, 2, 1);
    EXPECT_EQ(m3x3.inverse(), inverse2);

    Matrix m1x1{1,1};
    m1x1.set(0, 0, 1);
    EXPECT_ANY_THROW(m1x1.inverse());

    Matrix singular{2, 2};
    m2x2.set(0, 0, 1);
    m2x2.set(0, 1, 2);
    m2x2.set(1, 0, 2);
    m2x2.set(1, 1, 4);
    EXPECT_ANY_THROW(singular.inverse());

    Matrix m2x1{2, 1};
    m2x1.set(0, 0, 1);
    m2x1.set(1, 0, 2);
    EXPECT_ANY_THROW(m2x1.inverse());
}
/*** Konec souboru white_box_tests.cpp ***/
