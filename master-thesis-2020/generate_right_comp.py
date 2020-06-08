# -*- coding: utf-8 -*-
"""
Created on Wed Jun  3 17:59:05 2020

@author: solen
"""

import dash_core_components as dcc
import plotly_express as px
import dash_html_components as html
import numpy as np

min_slider = 0
max_slider = 10

def generate_graph(dataframe):
    fig = px.line(dataframe, x="time", y=[col for col in dataframe.columns],
                  labels={'x':'Tiifneruf'},
                  title='Comparison between Control and Post Escit Basal')
    return html.Div(
        className = 'main_component',
        id = 'graph',
        children = [dcc.Graph(figure=fig),
                    generate_slider(),
                    ])
        

def generate_slider(min = 0,max= 10):
    return dcc.RangeSlider(
        id='slider',
        allowCross=False,
        count=1,
        min=min,
        max=max,
        step=0.5,
        marks={
        min: str(min),
        max: str(max)
        },
        value=[1, 7])

def generate_tables(dataframe):
     return html.Div(
        className = 'main_component',
        id = 'data_tables',
        children = [
            generate_a_table(dataframe),
            generate_a_table(dataframe,first_row = 5),
            generate_a_table(dataframe,first_row = 10),
            generate_a_table(dataframe,first_row = 15)
            ]
        )
    
def generate_a_table(dataframe,max_rows = 5,first_row = 0): 
    return html.Table(
        className = 'tables',
        children=[
            html.Thead(
                    html.Tr([html.Th(col.capitalize()) for col in dataframe.columns])
                    ),
            html.Tbody([
                    html.Tr([
                            html.Td(np.round(dataframe.iloc[i + first_row][col],4)) for col in dataframe.columns
                            ]) for i in range(min(len(dataframe),max_rows))
                        ])
                    ])
        
        