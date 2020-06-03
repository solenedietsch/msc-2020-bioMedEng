# -*- coding: utf-8 -*-
"""
Created on Wed Jun  3 12:44:36 2020

@author: solen
"""
import dash
import dash_html_components as html
import generate_left_comp as glc
import generate_right_comp as grc

import pandas as pd

def generate_layout():
    return html.Div(children = [
        html.Header(
            children = html.H1(
                'The Hashemi Lab',
            )
        ),
        generate_body(),
        html.Footer(
            id = "footer",
            children = "FOOTER")
        ] 
        )

def generate_body():
    return html.Div(className = 'body',
                    children = [
                        generate_left_div(),
                        generate_right_div()
        ])

def generate_left_div():        
    return html.Div(
            className = 'body_div',
            id = 'body_left',
            children = [
                generate_left_top_div(),
                generate_left_bottom_div()
                ])                  
        
def generate_left_top_div():
    return html.Div(
        className = 'body_left_div',
        children=[
            glc.generate_upload_component(),
            glc.generate_table(df),
            ]
        
        )

def generate_left_bottom_div():
    return html.Div(className = 'body_left_div',
                    children = 'La partie du left bottom')

def generate_right_div():
        return html.Div(
            className = 'body_div',
            id = 'body_right',
            children = [
                grc.generate_graph(df),
                grc.generate_slider(0,10)
                ])                  
        

#external_stylesheets = ['https://codepen.io/chriddyp/pen/bWLwgP.css']
#app = dash.Dash(__name__,external_stylesheets = external_stylesheets)
# For example for now
df = pd.read_excel('data.xlsx')

app = dash.Dash(__name__)
app.layout = generate_layout()


if __name__ == '__main__':
    app.run_server(debug=True)