#    This file is part of Calculator - 4Exceptions.

#    Calculator - 4Exceptions is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or any later version.

#    Calculator - 4Exceptions is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.

#    You should have received a copy of the GNU General Public License
#    along with Calculator - 4Exceptions.  If not, see <https://www.gnu.org/licenses/>.

#    © 2021 4 Exceptions


## \mainpage
#Prostředí
#---------
#
#Ubuntu 64bit
#
#Autoři
#------
#
#4 Exceptions
#- xvasin11 Ladislav Vašina
#- xvagne10 Dominik Vágner
#- xpoliv06 Tomáš Polívka 
#- xhajek51 Vojtěch Hájek
#
#Licence
#-------
#
#Tento program je poskytován pod GNU GPL v.3
#© 2021 4 Exceptions



## @file calculator.py
## @brief Python file generating GUI and handling events associated with GUI
## @author GUI - Ladislav Vašina, xvasin11
## @date 05-04-2021

from tkinter import *
from tkinter import ttk

from input_file import input

## @var root
# Main window that is displayed to the user is saved in 'root' variable
root = Tk()
## Configuring window properties
root.title("Calculator – 4Exceptions")
root.configure(background='black')
root.minsize(366, 500)
root.geometry("366x500")
## Setting weight to rows and colums so they can be responsive
Grid.rowconfigure(root, 0, weight=1)
Grid.rowconfigure(root, 1, weight=1)
Grid.rowconfigure(root, 2, weight=1)
Grid.rowconfigure(root, 3, weight=1)
Grid.rowconfigure(root, 4, weight=1)
Grid.rowconfigure(root, 5, weight=1)
Grid.rowconfigure(root, 6, weight=1)

Grid.columnconfigure(root, 0, weight=1)
Grid.columnconfigure(root, 1, weight=1)
Grid.columnconfigure(root, 2, weight=1)
Grid.columnconfigure(root, 3, weight=1)


## @var e
# Main input field is saved in 'e' varible
e = Entry(root, width=80, bg="black", fg="white", font='sans 15 bold')
e.focus_set()
e.grid(row=0, column=0, columnspan=4, padx=0, pady=0, sticky="nsew")

## click function inserts given number to the Entry field
# @param[in] number -> outputs given varible to the entry field
def click(number):
    current = e.get()
    e.delete(0, END)
    e.insert(0, str(current) + str(number))

## clear function deletes everything in the Entry field
def clear():
    e.delete(0, END)

## remove_last function removes last character from current expession typed in the Entry field
def remove_last():
    current = e.get()
    e.delete(0, END)
    current = str(current)
    edited = current[:-1]
    e.insert(0, str(edited))

## output function outputs result to the Entry field
# @param[in] result
def output(result):
    e.insert(0, result)
    return

## function equal saves math expression to the 'expression' variable and calls input function also deletes the Entry field
# @param[out] expression -> is used in math libraries to resolve result
def equal():
    second_number = e.get()
    e.delete(0, END)
    expression=second_number
    result = input(expression)
    e.delete(0, END)
    output(result)
    return

## keyboard_entry function handles enter keyboard event and calls 'equal' function
# @param[in] event -> variable which holds event of the key that was pressed
def keyboard_entry(event):
    e.focus_set()
    if event.keysym=='KP_Enter' or event.keysym=='Return' or event.keysym=='equal':
        equal()
        
root.bind("<Key>", keyboard_entry)  

## Calculator buttons styling
btn_style = ttk.Style()
btn_style.configure('style.TButton', 
                borderwidth=0,
                padx=40,
                pady=20,
                background="#000000",
                foreground="#ffffff",
                font='sans 15 bold'    
               )
btn_style.map("style.TButton",
    foreground=[('!active', '#ffffff'),('pressed', '#ffffff'), ('active', '#ffffff')],
    background=[ ('!active','#000000'),('pressed', '#202020'), ('active', '#101010')]
    )
##@{    
# Defining buttons
one_btn = ttk.Button(root, style='style.TButton', text="1", command=lambda: click(1))
two_btn = ttk.Button(root, style='style.TButton', text="2", command=lambda: click(2))
three_btn = ttk.Button(root, style='style.TButton', text="3", command=lambda: click(3))
four_btn = ttk.Button(root, style='style.TButton', text="4", command=lambda: click(4))
five_btn = ttk.Button(root, style='style.TButton', text="5", command=lambda: click(5))
six_btn = ttk.Button(root, style='style.TButton', text="6", command=lambda: click(6))
seven_btn = ttk.Button(root, style='style.TButton', text="7", command=lambda: click(7))
eight_btn = ttk.Button(root, style='style.TButton', text="8", command=lambda: click(8))
nine_btn = ttk.Button(root, style='style.TButton', text="9", command=lambda: click(9))
zero_btn = ttk.Button(root, style='style.TButton', text="0", command=lambda: click(0))

add_btn = ttk.Button(root, style='style.TButton', text="+", command=lambda: click("+"))
subtract_btn = ttk.Button(root, style='style.TButton', text="-", command=lambda: click("-"))
equalIcon = PhotoImage(file="icons/equalIcon.png")
equal_btn = ttk.Button(root, style='style.TButton', image=equalIcon, command=equal)
clear_btn = ttk.Button(root, style='style.TButton', text="C", command=clear)
deleteIcon = PhotoImage(file="icons/deleteIcon.png")
delete_btn = ttk.Button(root, style='style.TButton', image=deleteIcon, command=remove_last)
nth_root_btn = ttk.Button(root, style='style.TButton', text="n√", command=lambda: click("n√"))
sqrt_btn = ttk.Button(root, style='style.TButton', text="√", command=lambda: click("2n√"))
modulo_btn = ttk.Button(root, style='style.TButton', text="mod", command=lambda: click("mod"))
factorial_btn = ttk.Button(root, style='style.TButton', text="!", command=lambda: click("!"))
power_btn = ttk.Button(root, style='style.TButton', text="^", command=lambda: click("^"))
binary_btn = ttk.Button(root, style='style.TButton', text="bin", command=lambda: click("bin"))
decimal_point_btn = ttk.Button(root, style='style.TButton', text=".", command=lambda: click("."))
multiply_btn = ttk.Button(root, style='style.TButton', text="*", command=lambda: click("*"))
divide_btn = ttk.Button(root, style='style.TButton', text="/", command=lambda: click("/"))
##@}

## Puting buttons on the screen
one_btn.grid(row=5, column=0, sticky="nsew")
two_btn.grid(row=5, column=1, sticky="nsew")
three_btn.grid(row=5, column=2, sticky="nsew")
four_btn.grid(row=4, column=0, sticky="nsew")
five_btn.grid(row=4, column=1, sticky="nsew")
six_btn.grid(row=4, column=2, sticky="nsew")
seven_btn.grid(row=3, column=0, sticky="nsew")
eight_btn.grid(row=3, column=1, sticky="nsew")
nine_btn.grid(row=3, column=2, sticky="nsew")
zero_btn.grid(row=6, column=1, sticky="nsew")

clear_btn.grid(row=1, column=2, sticky="nsew")
add_btn.grid(row=5, column=3, sticky="nsew")
equal_btn.grid(row=6, column=3, sticky="nsew")
subtract_btn.grid(row=4, column=3, sticky="nsew")
multiply_btn.grid(row=3, column=3, sticky="nsew")
divide_btn.grid(row=2, column=3, sticky="nsew")
delete_btn.grid(row=1, column=3, sticky="nsew")
nth_root_btn.grid(row=1, column=0, sticky="nsew")
sqrt_btn.grid(row=2, column=0, sticky="nsew")
modulo_btn.grid(row=1, column=1, sticky="nsew")
factorial_btn.grid(row=2, column=2, sticky="nsew")
power_btn.grid(row=2, column=1, sticky="nsew")
binary_btn.grid(row=6, column=0, sticky="nsew")
decimal_point_btn.grid(row=6, column=2, sticky="nsew")

## This function shows about window 
def show_about():
    about = Toplevel()
    about.geometry("300x150")
    about.minsize(300, 150)
## Creating content of about section
    Label(about, text="IVS Team Project 2021\n\n4 Exceptions calculator made by:\n Ladislav Vašina, xvasin11\n Dominik Vágner, xvagne10\n Tomáš Polívka, xpoliv06\n Vojtěch Hájek, xhajek51").pack()
    return

## This function shows help
def show_help():
    help_window = Toplevel()
    help_window.geometry("500x380")
    help_window.minsize(500, 380)
## Creating content of help section    
    Label(help_window, text='''

     n√ (nth root) is used in Xn√Y format.
     X is root's exponent and Y is number under the root symbol.

     mod (modulo) is used in this format: XmodY

     C button clears the input field

     √ (square root)is used in this format: √X

     ^ (power) is used in this format: X^Y
     Where X is an exponent of the root.
     
     ! (factorial) is used in this format: X!
     X is a number from which we want to get factorial of.

     bin (binary) is used in this format: binX
     Where X is a number which we want to convert to binary.

     +,-,*,/ works as it should. At least we hope so ( ͡° ͜ʖ ͡°).

     ''').pack()
    return 

## Creating menubar
menubar = Menu(root)
helpmenu = Menu(menubar, tearoff=0)
helpmenu.add_command(label="Help Index", command=show_help)
helpmenu.add_command(label="About", command=show_about)
menubar.add_cascade(label="Help", menu=helpmenu)

root.config(menu=menubar)
root.mainloop()
