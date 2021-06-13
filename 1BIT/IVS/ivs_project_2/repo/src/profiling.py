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

## @file profiling.py
## @brief profiling 
## @authors Tomáš Polívka (xpoliv06), Vojtěch Hájek (xhajek51)
## @date 23-04-2021

import math_functions as m
import cProfile
import re

## function profile_math 
#   prints rstandard deviation
#   @param values as array of numbers

def profile_math(values):
    sum = 0
    sum1 = 0
    x = len(values) 
    # Reading from the file
    for value in values:
        sum = m.add(sum, float(value))
    
    sum = m.divide(sum, x)    
    
    for value in values:
        sum1 = m.add(sum1, m.exponentiation(m.subtract(float(value),sum), 2))

    result = m.root(m.divide(sum1, x),2)
    print(result)

inp = input()
seperate_input = re.findall(r"[-+]?\d*\.\d+|[+-]?\d+", inp)
profile_math(seperate_input)

#cProfile.run('re.compile("profile_math")')




    
    

