# -*- coding: utf-8 -*-
"""
Created on Mon Jun  8 16:20:26 2020

@author: solen
"""

import pandas as pd

def calculate_components(dataframe,column1,column2,dv=0.1):
    series1 = dataframe[column1]
    series2 = dataframe[column2]
    

    value_at_peak = series2.max()
    value_at_peak_idx = series2.idxmax()
    value_at_half_life = value_at_peak/2

    troncated_series2 = series2.loc[value_at_peak_idx:]
    series2_btw = troncated_series2[troncated_series2.between(value_at_half_life - dv,value_at_half_life + dv)]
    
    half_life_value = series1.loc[abs(series2_btw - value_at_half_life).idxmin()]
    #half_life_value = series1.loc[abs(series2_btw - value_at_half_life).idxmin()] - series1.loc[value_at_peak_idx]
    return [value_at_peak,half_life_value]
    
df = pd.read_excel('data.xlsx')
print(df)

def calculate_half_life(series):
    '''
    This function will calculate the half_life from a specific time series
    Input: series - a time series
    '''