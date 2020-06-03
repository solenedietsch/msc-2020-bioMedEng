# -*- coding: utf-8 -*-
"""
Created on Wed Jun  3 16:11:17 2020

@author: solen
"""
import dash
import dash_core_components as dcc
import dash_html_components as html

def generate_upload_component():
    return dcc.Upload(
            className = 'body_left',
            id='upload-data',
            children=html.Div([
                'Drag and Drop or ',
                html.A('Select Files')
            ]),
            style={
                'width': '100%',
                'height': '60px',
                'lineHeight': '60px',
                'borderWidth': '1px',
                'borderStyle': 'dashed',
                'borderRadius': '5px',
                'textAlign': 'center'
            },
            # Allow multiple files to be uploaded
            multiple=True
        )
    
def generate_table(dataframe,max_rows = 5):
    return html.Table(
        className = 'body_left',
        style={
            'margin': 'auto'
            },
        children=[
            html.Thead(
                    html.Tr([html.Th(col) for col in dataframe.columns])
                    ),
            html.Tbody([
                    html.Tr([
                            html.Td(dataframe.iloc[i][col]) for col in dataframe.columns
                            ]) for i in range(min(len(dataframe),max_rows))
                        ])
                    ])