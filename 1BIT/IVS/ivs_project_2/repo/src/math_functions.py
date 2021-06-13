#    This file is part of Calculator - 4Exceptions.

#    Calculator - 4Exceptions is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or any later version.

#    Calculator - 4Exceptions is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.

#    You should have received a copy of the GNU General Public License

#    along with Calculator - 4Exceptions.  If not, see https://www.gnu.org/licenses/.

#    © 2021 4 Exceptions


## @file math_functions.py
## @brief library of mathematical functions
## @authors Tomáš Polívka (xpoliv06), Vojtěch Hájek (xhajek51)
## @date 13-04-2021

## function is_nan(num)
#  returns true if value is not a number
#  returns false if value is a number  
#  @param a number
def is_nan(num):
    try:
        float(num)
        return num != num
    except ValueError:
        return True

## function add(a,b) 
#  add two numbers and returns result
#  if one of them is not a number returns ValueError
#  @param a number
#  @param b number
def add(a, b):
    if is_nan(a) or is_nan(b):
        raise ValueError
    result = a + b
    if is_nan(result):
        raise ValueError
    else:    
        return result
    
## function subtract(a,b) 
#  subtracts two numbers and returns the result
#  if one of them is not a number returns ValueError
#  @param a number
#  @param b number
def subtract(a, b):
    if is_nan(a) or is_nan(b):
        raise ValueError    
    result = a - b
    if is_nan(result):
        raise ValueError
    else:    
        return result
    
## function multiply(a,b) 
#  multiplies two numbers and returns result
#  if one of them is not a number returns ValueError
#  @param a number
#  @param b number
def multiply(a, b):
    if is_nan(a) or is_nan(b):
        raise ValueError    
    result = a * b
    if is_nan(result):
        raise ValueError
    else:    
        return result
    
## function divide(a,b) 
#  divides two numbers and returns the result
#  if second number is equal to 0 returns ZeroDivisionError
#  if one of them is not a number returns ValueError
#  @param a number
#  @param b number
def divide(a, b):
    if b == 0: 
        raise ZeroDivisionError

    if is_nan(a) or is_nan(b):
        raise ValueError        

    result = a/b

    if is_nan(result):
        raise ValueError
    else: 
        return result

## function scientific
#  if a number's lenght is over 32 chars, return scientific number
#  else return normal a number
#  @param a number
def scientific(a):
    lenght=len(str(a))
    if lenght>=32:
        formatResult = format(a, ".15e")
        return formatResult
    else:
        return a

## function factorial
#  makes factorial from number 'a' and returns result
#  if number 'a' is lower than zero, returns ValueError
#  if overflow, return OverflowError
#  if its not a number, return ValueError
#  @param a number
def factorial(a):
    try:
        type(a) == int
        result = 1
        if a == 0:
            return result
        elif a<0:
            raise ValueError
        else:
            i=1
            while i<=a:
                result=float(result * i)
                i+=1
            return result
    except OverflowError:
        raise OverflowError
    except ValueError:
        raise ValueError

## function exponentiation
#  exponentiation of number 'a' to number 'n', returns result
#  if number 'n' is lower than zero, return ValueError
#  if overflow, return OverflowError
#  if its not a number, return ValueError
#  @param a number
#  @param n number
def exponentiation(a, n):
    if is_nan(a) and n == 0:
        return 1
    else:
        if is_nan(a):
            raise ValueError
        else:
            if n == 0:
                return 1
            else:
                try:
                    if n<0:
                        raise ValueError
                    else:
                        a = float(a)
                        result= float(a ** int(n))
                        return result
                except OverflowError:
                    raise OverflowError       

## function root
#  root of number 'a' to number 'n', returns result
#  if number 'a' is lower than zero, return ValueError
#  if 'n' equals zero, returns ZeroDivisionError
#  if its not a number, returns ValueError
#  @param a number
#  @param n number
def root(x, y):
    if is_nan(x) or is_nan(y):
        raise ValueError
    else:    
        if y == 0:
            raise ZeroDivisionError
        else:    
            if x == 0 and y < 0:
                raise ZeroDivisionError
            else:        
                if x < 0 and y % 2 == 0:
                    raise ValueError
                else:
                    try:
                        result = x ** float(1 / y)    
                        return result 
                    except OverflowError:
                        raise OverflowError    
## function int2bin
#  Integer number 'a' turns into bin format, return a in bin
#  number 'a' is divided by two, if modulo = 0, writes into string 0
#  number 'a' is divided by two, if modulo dont equals 0, writes into string 1
#  if number 'a' is float, return ValueError
#  if number 'a' is not Integer
#  @param a number
def int2bin(a):
    try:
        type(a) == int
        if type(a) == float:
            raise ValueError
        i=int(a)
        result=""
        if a == 0:
            return "0b0"
        if a <0:
            i=-i
        while i>0:
            j=int(i % 2)
            i=int(i // 2)
            if j==0:
                result= "0" + result
            else:
                result= "1" + result
        if a<0:
            return "-0b" + result
        else:
            return "0b" + result
    except ValueError:
        raise ValueError

## function modulo
#  makes modulo from number 'a' and number 'b', returns result
#  if number 'b' equals zero, returns ZeroDivisionError
#  if number 'a' is not number, returns ValueError
#  @param a number
#  @param b number
def modulo(a, b):
    try:
        type(a) == int or float
        type(b) == int or float
        result= a % b
        return result
    except ZeroDivisionError:
        raise ZeroDivisionError
    except ValueError:
        raise ValueError
