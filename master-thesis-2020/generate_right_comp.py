# -*- coding: utf-8 -*-
"""
Created on Wed Jun  3 17:59:05 2020

@author: solen
"""

import dash_core_components as dcc
import plotly_express as px

min_slider = 0
max_slider = 10

def generate_graph(dataframe):
    fig = px.line(dataframe, x="time", y=["Control","Post ESCIT Basal"], title='Control')
    return dcc.Graph(
        className = 'body_right',
        id = 'graph',
        figure=fig)

def generate_slider(min = 0,max= 10):
    return dcc.RangeSlider(
        className = 'body_right',
        id='range_slider',
        allowCross=False,
        count=1,
        min=min,
        max=max,
        step=0.5,
        value=[1, 7])