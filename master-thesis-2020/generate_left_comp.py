# -*- coding: utf-8 -*-
"""
Created on Wed Jun  3 16:11:17 2020

@author: solen
"""

import dash_core_components as dcc
import dash_html_components as html
import numpy as np
import data_analysis

def generate_upload_component():
    return dcc.Upload(
            className = 'main_component',
            id = 'upload-data',
            children=html.Div([
                'Drag and Drop or ',
                html.A('Select Files')
            ]),
            # Allow multiple files to be uploaded
            multiple=True
        )

def generate_name_file(dataframe):
    return html.Div(
        className = 'main_component',
        id = 'files-div',
        children = [html.H4('Available files'),
                    dcc.Checklist(
                    options=[
                        {'label': 'Control file 1', 'value': 'CONTROL1'},
                        {'label': 'Post ESCIT Basal', 'value': 'POST1'},
                        {'label': 'Control file 2', 'value': 'CONTROL2'},
                        {'label': 'Post ESCIT Basal', 'value': 'POST2'},
                        {'label': 'Control file 3', 'value': 'CONTROL3'},
                        {'label': 'Post ESCIT Basal', 'value': 'POST3'}
                    ],
                    value=['CONTROL1', 'POST1'],
                    )  
                    ]
        )
    
def generate_results(dataframe):
    
    return html.Div(
        className = 'main_component',
        id = 'results',
        children = [html.H4('Results'),
                    generate_table_result(dataframe)]
        )

def generate_table_result(dataframe):
    [peak_value_control,half_life_control] = data_analysis.calculate_components(dataframe,'time','Control')
    [peak_value_post,half_life_post] = data_analysis.calculate_components(dataframe,'time','Post',3)
    
    return html.Table(
        id ='result_table',
        children=[
            html.Thead(
                    html.Tr([html.Th(col.capitalize()) for col in ['Parameter','Control','Post']])
                    ),
            html.Tbody([html.Tr([
                html.Td('Peak value'),  
                html.Td(np.round(peak_value_control,3)),
                html.Td(np.round(peak_value_post,3))
                ]),
                html.Tr([
                html.Td('Half life value'),  
                html.Td(np.round(half_life_control,3)),
                html.Td(np.round(half_life_post,3))
                ])]
                )
                ])

