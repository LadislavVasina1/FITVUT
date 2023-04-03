#!/usr/bin/env python3
"""
IZV cast1 projektu
Autor: Ladislav Vašina, xvasin11, 2022

Detailni zadani projektu je v samostatnem projektu e-learningu.
Nezapomente na to, ze python soubory maji dane formatovani.

Muzete pouzit libovolnou vestavenou knihovnu a knihovny predstavene na prednasce
"""

from bs4 import BeautifulSoup
import requests
import numpy as np
import matplotlib.pyplot as plt
from typing import List
from numpy import ma


def integrate(x: np.array, y: np.array) -> float:
    """
    Function integrates the function using the trapezoidal rule

    :param x: ordered numpy vector of x values
    :param y: numpy vector of y values
    :return: result of the integration
    """
    return (x[1:] - x[:-1]) * (0.5 * (y[1:] + y[:-1])).sum()


def generate_graph(a: List[float], show_figure: bool = False, save_path: str | None = None):
    """
    Function generates a graph of the given data

    :param a: list of floats
    :param show_figure: flag stating whether to show the figure or not
    :param save_path: save path for the plot
    :return: nothing (shows or saves the plot)
    """
    x = np.arange(-3, 3.1, 0.1)
    func_results = x ** 2 * np.array(a).reshape(3, 1)
    fig = plt.figure()
    ax = fig.add_subplot(1, 1, 1)
    ax.set_xlabel('x')
    ax.set_ylabel(r"$f_a(x)$")
    # plot the function
    plt.plot(x, func_results[0], color='blue', label=r'$y_{1.0}(x)$')
    ax.fill_between(x, func_results[0], color='orange', alpha=0.2)
    plt.plot(x, func_results[1], color='orange', label=r'$y_{2.0}(x)$')
    ax.fill_between(x, func_results[1], color='orange', alpha=0.2)
    plt.plot(x, func_results[2], color='green', label=r'$y_{-2.0}(x)$')
    ax.fill_between(x, func_results[2], color='lightgreen', alpha=0.3)
    plt.margins(0)
    plt.yticks([-20, -15, -10, -5, 0, 5, 10, 15, 20])
    plt.ylim([-22, 22])
    ax.legend(loc='upper center', bbox_to_anchor=(0.5, 1.13), ncol=len(ax.lines))
    ax.annotate(r"$\int f_{1.0}(x)dx$", xy=(3, 10), xytext=(3, 9))
    ax.annotate(r"$\int f_{2.0}(x)$dx", xy=(3, 10), xytext=(3, 17))
    ax.annotate(r"$\int f_{-2.0}(x)dx$", xy=(3, 10), xytext=(3, -19))
    ax.spines["top"].set_bounds(-3, 3.7)
    ax.spines["bottom"].set_bounds(-3, 3.7)
    ax.spines["right"].set_position(("data", 3.7))
    fig.set_size_inches(10, 5)
    # show or save the plot
    if show_figure:
        plt.show()
    else:
        plt.savefig(save_path)
    plt.close()


def generate_sinus(show_figure: bool = False, save_path: str | None = None):
    """
    Function generates a graphs of the sinus functions

    :param show_figure: flag stating whether to show the figure or not
    :param save_path: save path for the plot
    :return: nothing (shows or saves the plot)
    """
    sinus = np.sin
    pi = np.pi
    t = np.arange(0, 100.01, 0.01)
    f1 = 0.5 * sinus(0.02 * pi * t)
    f2 = 0.25 * sinus(pi * t)
    f3 = f1 + f2

    fig, (ax1, ax2, ax3) = plt.subplots(3, 1)
    fig.set_figheight(10)
    fig.set_figwidth(7)
    fig.subplots_adjust(hspace=0.5)
    ax1.plot(t, f1)
    ax1.margins(x=0, y=0)
    ax1.set_yticks([-0.8, -0.4, 0, 0.4, 0.8])
    ax1.set_ylabel(r"$f_1(t)$")

    ax2.plot(t, f2)
    ax2.margins(x=0, y=0)
    ax2.set_yticks([-0.8, -0.4, 0, 0.4, 0.8])
    ax2.set_ylabel(r"$f_2(t)$")

    mask = ma.masked_greater(f3, f1)
    ax3.plot(t, f3, 'g')
    ax3.plot(t, mask, 'r')
    ax3.margins(x=0, y=0)
    ax3.set_yticks([-0.8, -0.4, 0, 0.4, 0.8])
    ax3.set_ylabel(r"$f_3(t)$")

    # show or save the plot
    if show_figure:
        plt.show()
    else:
        plt.savefig(save_path)
    plt.close()


def download_data(url="https://ehw.fit.vutbr.cz/izv/temp.html"):
    """
    Function downloads the data from the given url

    :param url: url from which to download the data
    :return: parsed data from the given url
    """
    data_output = []
    response = requests.get(url).text
    bs = BeautifulSoup(response, 'html.parser')
    table = bs.find('table', class_='ta1')
    rows = table.find_all('tr')
    for i in range(0, len(rows)):
        temp = []
        for entry in rows[i].find_all('p')[2:]:
            temp.append(float(entry.text.replace(',', '.')))
        year = int(rows[i].find_all('p')[0].text)
        month = int(rows[i].find_all('p')[1].text)
        np_temp = np.array(temp)
        month_dict = {"year": year, "month": month, "temp": np_temp}
        data_output.append(month_dict)

    return data_output


def get_avg_temp(data, year=None, month=None) -> float:
    """
    Function that shows average temperature for given year and month

    :param data: data from which to get the average temperature from
    :param year: year from which to get the average temperature from
    :param month: month from which to get the average temperature from
    :return: float value of the average temperature
    """
    if month:
        month = int(month)

    if not year and not month:
        temperatures = []
        for i in range(0, len(data)):
            temperatures = np.append(temperatures, data[i]["temp"])
        return np.average(temperatures)

    if year and month:
        temperatures = []
        for i in range(0, len(data)):
            if data[i]["year"] == year and data[i]["month"] == month:
                temperatures = np.append(temperatures, data[i]["temp"])
        return np.average(temperatures)

    if year:
        temperatures = []
        for i in range(0, len(data)):
            if data[i]["year"] == year:
                temperatures = np.append(temperatures, data[i]["temp"])
        return np.average(temperatures)

    if month:
        temperatures = []
        for i in range(0, len(data)):
            if data[i]["month"] == month:
                temperatures = np.append(temperatures, data[i]["temp"])
        return np.average(temperatures)
