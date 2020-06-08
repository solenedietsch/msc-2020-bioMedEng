# -*- coding: utf-8 -*-
"""
Created on Wed Jun  3 16:11:17 2020

@author: solen
"""

import dash_core_components as dcc
import dash_html_components as html
import numpy as np

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

def generate_name_file():
    return html.Div(
        className = 'main_component',
        id = 'files-div',
        children = [html.H4('Selected files'),
                    html.P(
                        html.Ul([
                            html.Li('File 1'),
                            html.Li('File 2'),
                            html.Li('File 3'),
                            html.Li(' ... ')
                            ])
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
        return html.Table(
            id ='result_table',
            children=[
                html.Thead(
                        html.Tr([html.Th(col.capitalize()) for col in ['Parameter','Control','Post']])
                        ),
                html.Tbody([
                        html.Tr([
                                html.Td(np.round(dataframe.iloc[i][col],4)) for col in dataframe.columns
                                ]) for i in range(min(len(dataframe),4))
                            ])
            ])