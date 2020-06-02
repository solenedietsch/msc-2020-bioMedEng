# -*- coding: utf-8 -*-
"""
Created on Fri May 29 13:29:19 2020

@author: solen
"""

import dash
import dash_core_components as dcc
import dash_html_components as html
import pandas as pd


import plotly_express as px
import plotly
plotly.__version__




df = pd.read_excel('data.xlsx')
#print(df.columns)
#fig = px.line(df, x='time', y='Control')
#fig.show()
##df2 = pd.concat(df['time','Control'],df['time','Post ESCIT Basal'])
#print(df2)
#df['time'] = df.index
#df_melt = pd.melt(df, id_vars="x", value_vars=df.columns[:-1])
#px.line(df_melt, x="x", y="value",color="variable")

#print(df['Control'])
#print(df['Post ESCIT Basal'])
#print(df['time'])
def generate_table(dataframe,max_rows = 10):
    return html.Table([
            html.Thead(
                    html.Tr([html.Th(col) for col in dataframe.columns])
                    ),
            html.Tbody([
                    html.Tr([
                            html.Td(dataframe.iloc[i][col]) for col in dataframe.columns
                            ]) for i in range(min(len(dataframe),max_rows))
                        ])
                    ])
def generate_slider(min = 0,max= 10):
    return dcc.RangeSlider(
        id='range_slider',
        allowCross=False,
        count=1,
        min=min,
        max=max,
        step=0.5,
        marks={min:min,
               max:max},
        value=[1, 7])

def generate_graph1(dataframe):
    fig = px.line(dataframe, x="time", y=["Control","Post ESCIT Basal"], title='Control')
   #fig.add_trace(px.line(dataframe, x="time", y="Post ESCIT Basal"))
    return dcc.Graph(
            figure=fig)
    
def generate_graph2(dataframe):
    fig = px.line(dataframe, x="time", y="Post ESCIT Basal")
    return dcc.Graph(
            figure=fig)

def generate_upload_button():
    return html.Div([
            dcc.Upload(html.Button('Upload File')),
    
            html.Hr(),
        
            dcc.Upload([
                'Drag and Drop or ',
                html.A('Select a File')
            ], style={
                'width': '100%',
                'height': '60px',
                'lineHeight': '60px',
                'borderWidth': '1px',
                'borderStyle': 'dashed',
                'borderRadius': '5px',
                'textAlign': 'center'
            })    
    
    ])
    
external_stylesheets = ['https://codepen.io/chriddyp/pen/bWLwgP.css']
app = dash.Dash(__name__, external_stylesheets=external_stylesheets)

app.layout = html.Div(children=[
        html.H4(children='Data'),
        html.Div(id='output_container_range_slider'),
        generate_table(df,5),
        generate_graph1(df),
        generate_graph2(df),
        generate_slider(min = 0,max= 10)
        #generate_upload_button()
])

@app.callback(
    dash.dependencies.Output('output_container_range_slider', 'children'),
    [dash.dependencies.Input('range_slider', 'value')])

def update_output(value):
    return 'You have selected "{}"'.format(value)

if __name__ == '__main__':
    app.run_server(debug=False)