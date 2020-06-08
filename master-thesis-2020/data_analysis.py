# -*- coding: utf-8 -*-
"""
Created on Mon Jun  8 16:20:26 2020

@author: solen
"""

import pandas as pd

df = pd.read_excel('data.xlsx')
print(df)

def calculate_half_life(series):
    '''
    This function will calculate the half_life from a specific time series
    Input: series - a time series
    '''