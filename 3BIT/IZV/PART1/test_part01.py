#!/usr/bin/env python3
"""
Skript pro automaticke testovani prvni casti projektu.

Tento soubor se neodevzdava, takze sem nepiste sve reseni!
To, ze vas skript projde timto testem, nemusi nutne znamenat, 
ze je vase reseni spravne!

Spousteni:
   pytest
nebo
   python3 -m pytest
"""
import part01
import numpy as np
import os
import pytest


def test_integrate():
    """Test vypoctu integralu """
    x = np.linspace(0, 1, 100)
    r = part01.integrate(x, 10 * x + 2)

    assert r == pytest.approx(7)


def test_generate_fn():
    """Test generovani grafu s vice funkcemi"""
    part01.generate_graph([1., 2., -2.], show_figure=False,
                          save_path="tmp_fn.png")
    assert os.path.exists("tmp_fn.png")


def test_generate_sin():
    """Test generovani grafu se sinusovkami"""
    part01.generate_sinus(show_figure=False, save_path="tmp_sin.png")
    assert os.path.exists("tmp_sin.png")


def test_download():
    """Test stazeni dat"""
    data = part01.download_data()

    assert len(data) == 3 * 12
    assert data[0]["year"] == 2018
    assert data[0]["month"] == 1
    assert data[0]["temp"].shape == (31,)
    assert data[1]["temp"].shape == (28,)


def test_calculation():
    """Test zpracovani dat pres mesic a pres rok"""
    data = part01.download_data()

    m = part01.get_avg_temp(data, month=5)
    assert m == pytest.approx(14.919354)
    y = part01.get_avg_temp(data, year=2020)

    assert y == pytest.approx(10.936066)

#%%
