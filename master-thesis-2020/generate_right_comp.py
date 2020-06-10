# -*- coding: utf-8 -*-
"""
Created on Wed Jun  3 17:59:05 2020

@author: solen
"""

import dash_core_components as dcc
import dash_html_components as html
import plotly_express as px
import plotly.graph_objects as go
import numpy as np
import data_analysis

min_slider = 0
max_slider = 10

def add_horizontal_line(self,dataframe,column_name,y,col= "RoyalBlue"):
        self.add_shape(
        # Line Vertical
        dict(
            type="line",
            x0=dataframe[column_name].min(),
            y0=y,
            x1=dataframe[column_name].max(),
            y1=y,
            line=dict(
                color= col,
                dash="dash"
            )
            ))
        return

def add_vertical_line(self,dataframe,column1,column2,x,col= "RoyalBlue"):
        self.add_shape(
        # Line Vertical
        dict(
            type="line",
            x0=x,
            y0=0,
            x1=x,
            y1=max(dataframe[column1].max(),dataframe[column2].max()),
            line=dict(
                color= col,
                dash="dash"
            )
            ))
        return
    
    
def generate_graph(dataframe):
    [peak_value_control,half_life_control] = data_analysis.calculate_components(dataframe,'time','Control')
    [peak_value_post,half_life_post] = data_analysis.calculate_components(dataframe,'time','Post',3)
    
    fig = go.Figure()
    fig.add_trace(go.Scatter(x=dataframe['time'], y=dataframe['Control'],
                    mode='lines',
                    name='Control'))
    fig.add_trace(go.Scatter(x=dataframe['time'], y=dataframe['Post'],
                mode='lines',
                name='Post ESCIT Basal'))
    add_horizontal_line(fig,dataframe,'time',peak_value_control)
    add_horizontal_line(fig,dataframe,'time',peak_value_control/2)
    add_vertical_line(fig,dataframe,'Control','Post',half_life_control)
    
    add_horizontal_line(fig,dataframe,'time',peak_value_post,'red')
    add_horizontal_line(fig,dataframe,'time',peak_value_post/2,'red')
    add_vertical_line(fig,dataframe,'Control','Post',half_life_post,'red')  
    
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
        
        