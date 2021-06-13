//======== Copyright (c) 2021, FIT VUT Brno, All rights reserved. ============//
//
// Purpose:     White Box - matrix class code
//
// $NoKeywords: $ivs_project_1 $white_box_code.cpp
// $Author:     LADISLAV VAŠINA <xvasin11stud.fit.vutbr.cz>
// $Date:       $2021-01-04
//============================================================================//
/**
 * @file white_box_code.cpp
 * @author LADISLAV VAŠINA
 * 
 * @brief Definice metod tridy reprezentujici matici.
 */

#include <iostream>
#include <stdexcept>

#include "white_box_code.h"

Matrix::Matrix(): mRows(1), mCols(1)
{
    matrix = std::vector<std::vector< double > >(1, std::vector<double>(1, 0));
}

Matrix::Matrix(size_t row, size_t col): mRows(row), mCols(col)
{
    if(row < 1 || col < 1)
        throw std::runtime_error("Minimalni velikost matice je 1x1");
    
    matrix = std::vector<std::vector< double > >(row, std::vector<double>(col, 0));
}

Matrix::~Matrix()
{

}

bool Matrix::set(size_t row, size_t col, double value)
{
    if(!checkIndexes(row, col))
        return false;
    
    matrix[row][col] = value;
    
    return true;
}

bool Matrix::set(std::vector<std::vector< double > > values)
{
    bool fit = true;

    if(matrix.size() != values.size())
    {
        fit = false;
    }

    for(int r = 0; r < matrix.size(); r++)
    {
        if(values[r].size() != matrix[r].size())
        {
            fit = false;
        }
    }

    if(!fit)
    {
        return fit;
    }
    
    for(int r = 0; r < matrix.size(); r++)
    {
        for(int c = 0; c < matrix[0].size(); c++)
        {
            matrix[r][c] = values[r][c];
        }
    }
    
    return true;
}

double Matrix::get(size_t row, size_t col)
{
    if(!checkIndexes(row, col))
        throw std::runtime_error("Pristup k indexu mimo matici");

    return matrix[row][col];
}

bool Matrix::operator==(const Matrix m) const
{
    if(!checkEqualSize(m))
        throw std::runtime_error("Matice musi mit stejnou velikost.");
    
    for(int r = 0; r < matrix.size(); r++)
    {
        for (int c = 0; c < matrix[r].size(); c++)
        {
            if(matrix[r][c] != m.matrix[r][c])
                return false;
        }
    }
    
    return true;
}

Matrix Matrix::operator+(const Matrix m) const
{
    if(!checkEqualSize(m))
        throw std::runtime_error("Matice musi mit stejnou velikost.");
    
    Matrix result = Matrix(matrix.size(), matrix[0].size());
    
    for(int r = 0; r < matrix.size(); r++)
    {
        for(int c = 0; c < matrix[r].size(); c++)
        {
            result.set(r, c, matrix[r][c] + m.matrix[r][c]);
        }
    }
    
    return result;
}


Matrix Matrix::operator*(const Matrix m) const
{
    if(matrix[0].size() == m.matrix.size())
    {
        Matrix result = Matrix(matrix.size(), m.matrix[0].size());
        
        for(int r = 0; r < matrix.size(); r++)
        {
            for(int c = 0; c < m.matrix[0].size(); c++)
            {
                for(int i = 0; i < matrix[r].size(); i++)
                {
                    result.set(r, c, result.get(r, c) +  matrix[r][i] * m.matrix[i][c]);
                }
            }
        }
        
        return result;
    }
    else
    {
        throw std::runtime_error("Prvni matice musi stejny pocet sloupcu jako druha radku.");
    }
}

Matrix Matrix::operator*(const double value) const
{
    Matrix result = Matrix(matrix.size(), matrix[0].size());
  
    for(int r = 0; r < matrix.size(); r++)
    {
        for(int c = 0; c < matrix[r].size(); c++)
        {
            result.set(r, c, matrix[r][c] * value);
        }
    }
    
    return result;
}

std::vector<double> Matrix::solveEquation(std::vector<double> b)
{
    std::vector<double> res = std::vector<double>(matrix.size(), 0);
    
    std::vector<std::vector<double> > temp = 
        std::vector<std::vector< double > >(matrix.size(), std::vector<double>(matrix.size(), 0));
        
    if(matrix[0].size() != b.size())
        throw std::runtime_error("Pocet prvku prave strany rovnice musi odpovidat poctu radku matice.");
    
    if(!checkSquare())
        throw std::runtime_error("Matice musi byt ctvercova.");
  
    double determinatAll = determinant();
  
    if(abs(determinatAll) < std::numeric_limits<double>::epsilon())
        throw std::runtime_error("Matice je singularni.");
    
    for(int i = 0; i < matrix.size(); i++)
    {
        for(int j = 0; j < matrix[i].size(); j++)
        {
            temp[i][j] = matrix[i][j];
        }
    }
    
    for(int i = 0; i < matrix.size(); i++)
    {
        for(int k = 0; k < matrix[i].size(); k++)
        {
            temp[k][i] = b[k];
        }
        
        res[i] = deter(temp, temp.size())/determinatAll;
        
        for(int k = 0; k < matrix[i].size(); k++)
            temp[k][i] = matrix[k][i];
    }
    
    return res;
}

bool Matrix::checkIndexes(size_t row, size_t col)
{
    if(row >= matrix.size() || col >=  matrix[0].size())
        return false;
  
    return true;
}

bool Matrix::checkSquare()
{
    if(matrix.size() == matrix[0].size())
        return true;
    
    return false;
}

bool Matrix::checkEqualSize(const Matrix m) const
{
    if(m.matrix.size() == matrix.size() && m.matrix[0].size() ==  matrix[0].size())
        return true;
    
    return false;
}

double Matrix::determinant()
{
    if(matrix.size() == 1)
    {
        return matrix[0][0];
    }
    else if(matrix.size() == 2)
    {
        return matrix[0][0]*matrix[1][1] - matrix[1][0]*matrix[0][1];
    }
    else if(matrix.size() == 3)
    {
        return matrix[0][0]*matrix[1][1]*matrix[2][2] +
            matrix[0][1]*matrix[1][2]*matrix[2][0] + 
            matrix[0][2]*matrix[1][0]*matrix[2][1] - 
            matrix[2][0]*matrix[1][1]*matrix[0][2] - 
            matrix[2][1]*matrix[1][2]*matrix[0][0] - 
            matrix[2][2]*matrix[0][1]*matrix[1][0];
    
    }
    else
    {
        return deter(matrix, matrix.size());
    }
}


std::vector< std::vector<double> > getMinimo( std::vector< std::vector<double> > src, int I, int J, int ordSrc )
{
    std::vector< std::vector<double> > minimo( ordSrc-1, std::vector<double> (ordSrc-1,0));

    int rowCont = 0;
    
    for(int i=0; i < ordSrc; i++)
    {
        int colCont = 0;
        
        if(i != I)
        {
            for(int j=0; j < ordSrc; j++)
            {
                if(j != J)
                {
                    minimo[rowCont][colCont] = src[i][j];
                    colCont++; 
                }
            }
            
            rowCont++;
        }
    }
    
    return minimo;
}

double Matrix::deter(std::vector<std::vector<double> > m, size_t n)
{
    if(n == 1)
        return m[0][0];

    if(n == 2)
    {
        double mainDiag = m[0][0] * m[1][1];
        double negDiag = m[1][0] * m[0][1];

        return mainDiag - negDiag; 
    }
    else
    {
        double det = 0;
        for(int J = 0; J < n; J++)
        {
            std::vector< std::vector<double> > min = getMinimo( m, 0, J, n);
            if((J % 2) == 0)
            {
                det += m[0][J] * deter( min, n-1);
            }
            else
            {
                det -= m[0][J] * deter( min, n-1);
            }
        }
        
        return det;
    }
    
    return 0;
}

Matrix Matrix::transpose()
{
    Matrix transposedMatrix(mCols, mRows);
    for(int r = 0; r < mRows; r++)
    {
        for(int c = 0; c < mCols; c++)
        {
            transposedMatrix.set(c,r, matrix[r][c]);
        }
    }

    return transposedMatrix;
}

Matrix Matrix::inverse()
{
    Matrix inversedMatrix(mRows, mCols);

    if(!(mRows == 2 && mCols == 2) && !(mRows == 3 && mCols == 3))
    {
        throw std::runtime_error("Matice musi byt velikosti 2x2 nebo 3x3.");
    }

    double deter = determinant();
    if( abs(deter) < std::numeric_limits<double>::epsilon() )
    {
        throw std::runtime_error("Matice je singularni.");
    }

    if(mRows == 2 && mCols == 2)
    {
        inversedMatrix.set(0, 0, matrix[1][1] / deter);
        inversedMatrix.set(1, 0, -1.0 * matrix[1][0] / deter);
        inversedMatrix.set(0, 1, -1.0 * matrix[0][1] / deter);
        inversedMatrix.set(1, 1, matrix[0][0] / deter);
    }
    else
    {
        for(int r = 0; r < mRows; r++)
        {
            for(int c = 0; c < mCols; c++)
            {
                inversedMatrix.set(c, r, (matrix[(r+1)%3][(c+1)%3]*matrix[(r+2)%3][(c+2)%3] - matrix[(r+2)%3][(c+1)%3]*matrix[(r+1)%3][(c+2)%3]) / deter);
            }
        }
    }

    return inversedMatrix;
}

/*** Konec souboru white_box_code.cpp ***/