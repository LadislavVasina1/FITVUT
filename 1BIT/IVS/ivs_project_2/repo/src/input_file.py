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


## @file input_file.py
## @brief input processing
## @author Vojtěch Hájek (xhajek51), Tomáš Polívka (xpoliv06)
## @date 15-04-2021

import math_functions as m
import re


## function input(cal_input)
#  proccesing input string
#  seperate string into numbers
#  avoids invalid entry
#  avoids overflow
#  avoids zero division error
#  first checks and counts priority functions as multiply, divide
#  than collects result and make final result
#  return final result of input string
def input(cal_input):
        # seperate input string by operations and numbers
        seperate_input = re.findall(r"[-+]?\d*\.\d+|\d+|\+|\-|\/|\^|\*|\!|[bin]+[mod]+|[n√]+|[a-z]+", cal_input)
        base = []
        advanced = []
        other = []
        j=0
        # try ecxept for invalid input or errors in processing
        try:    
                if seperate_input[0]=="+" or seperate_input[0]=="-":
                        seperate_input.insert(0,0)
                i=0        
                for x in seperate_input:
                        if x == "!":
                                seperate_input.insert(i+1,'1')
                        i+=1
                i=0
                # seperates operation into individual fields
                for x in seperate_input:
                        if x == "bin":
                                other += [j]
                        if x == "*" or x=="/" or x=="^" or x == "mod" or x=="n√" or x=="!":
                                advanced += [j]
                        if x == "+" or x == "-":
                                base += [j]
                        j+=1

                # process only alone operations
                if len(other) != 0:
                        if len(other) == 1 and len(advanced) == 0 and len(base) == 0:
                                x=other[0]
                                if seperate_input[x] == "bin":
                                        a=int(seperate_input[x+1])
                                        finalResult=m.int2bin(a)
                        else:
                                return "Invalid entry"
                if len(seperate_input)<3 and len(other)==0:
                        return "Invalid entry"
                
                # process advanced operations, because of priority
                if len(advanced) !=0:
                        i=0
                        for x in advanced:
                                a=float(seperate_input[x-1])
                                b=float(seperate_input[x+1])
                                result=0
                                if seperate_input[x] == "*":
                                        result=m.multiply(a, b)
                                if seperate_input[x] == "/":
                                        result=m.divide(a, b)
                                if seperate_input[x] == "^":
                                        result=m.exponentiation(a, b)
                                if seperate_input[x] == "n√":
                                        result=m.root(b, a)     
                                if seperate_input[x] == "mod":
                                        result=m.modulo(a,b)
                                if seperate_input[x] == "!":
                                        result=m.factorial(a)

                                if i==len(advanced)-1:
                                        seperate_input[x-1]=result
                                else:
                                        if advanced[i+1] == x+2:
                                                y=advanced[i+1]
                                                seperate_input[y-1]=result
                                        else:
                                                seperate_input[x-1]=result
                                i+=1

                lenght=len(advanced)-1
                x=0
                # removes operations if is sequance of priority operations
                while x<lenght:
                        if x!=lenght:
                                if advanced[x+1] == advanced[x]+2:
                                        del advanced[x: x+1]
                                        x-=1
                                        lenght -=1
                        elif x==lenght and advanced[x-1] == advanced[x]+2:
                                del advanced[x: x+1]
                        x+=1

                # process standard operations or calculates with results from priority operations
                if len(base) !=0:
                        lenghtAdv=len(advanced)-1
                        lenghtBas=len(base)-1
                        adv=0
                        i=0
                        for x in base:
                                if len(advanced)!=0:
                                        if i!=lenghtBas:
                                                if i==0 and adv==0 and adv!=lenghtAdv:
                                                        if base[i] > advanced[adv] and base[i+1]>advanced[adv+1]:
                                                                t1=advanced[adv]
                                                                t2=advanced[adv+1]
                                                                a=float(seperate_input[t1-1])
                                                                b=float(seperate_input[t2-1])
                                                                adv+=2
                                                        elif base[i]>advanced[adv]:
                                                                t=advanced[adv]
                                                                a=float(seperate_input[t-1])
                                                                b=float(seperate_input(x+1))
                                                                adv+=1
                                                        elif base[i+1] > advanced[adv]:
                                                                t=advanced[adv]
                                                                a=float(seperate_input[x-1])
                                                                b=float(seperate_input[t-1])
                                                                adv+=1
                                                        else:
                                                                a=float(seperate_input[x-1])
                                                                b=float(seperate_input[x+1])
                                                elif adv!=lenghtAdv:
                                                        if base[i+1] > advanced[adv]:
                                                                t=advanced[adv]
                                                                a=float(seperate_input[x-1])
                                                                b=float(seperate_input[t-1])
                                                                adv+=1
                                                        else:
                                                                a=float(seperate_input[x-1])
                                                                b=float(seperate_input[x+1])
                                                elif adv==lenghtAdv:
                                                        if base[i+1] > advanced[adv]:
                                                                t=advanced[adv]
                                                                a=float(seperate_input[x-1])
                                                                b=float(seperate_input[t-1])
                                                        else:
                                                                a=float(seperate_input[x-1])
                                                                b=float(seperate_input[x+1])
                                        elif i==lenghtBas:
                                                if adv==lenghtAdv:
                                                        if base[i] < advanced[adv]:
                                                                t=advanced[adv]
                                                                a=float(seperate_input[x-1])
                                                                b=float(seperate_input[t-1])
                                                        elif base[i] > advanced[adv]:
                                                                t=advanced[adv]
                                                                a=float(seperate_input[t-1])
                                                                b=float(seperate_input[x+1])
                                                        else:
                                                                a=float(seperate_input[x-1])
                                                                b=float(seperate_input[x+1])
                                                else:
                                                        if base[i] > advanced[adv] and base[i]<advanced[adv+1]:
                                                                t1=advanced[adv]
                                                                t2=advanced[adv+1]
                                                                a=float(seperate_input[t1-1])
                                                                b=float(seperate_input[t2-1])
                                                                adv+=2
                                                        else:
                                                                a=float(seperate_input[x-1])
                                                                b=float(seperate_input[x+1])
                                else:
                                        a=float(seperate_input[x-1])
                                        b=float(seperate_input[x+1]) 

                                if seperate_input[x] == "+":
                                        result=m.add(a, b)
                                if seperate_input[x] == "-":
                                        result=m.subtract(a, b)
                                if i==len(base)-1:
                                        seperate_input[x-1]=result
                                        finalResult=result
                                else:
                                        t=base[i+1]
                                        seperate_input[t-1]=result
                                i+=1        

                if len(advanced) !=0 and len(base)==0:
                        y=advanced[0]
                        finalResult=seperate_input[y-1]

                return finalResult
        except IndexError:
                return "Invalid entry"
        except ValueError:
                return "Invalid entry"
        except OverflowError:
                return "Overflow"
        except ZeroDivisionError:
                return "Zero cannot be divided"
