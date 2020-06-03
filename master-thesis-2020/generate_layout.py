# -*- coding: utf-8 -*-
"""
Created on Wed Jun  3 12:44:36 2020

@author: solen
"""
import dash
import dash_html_components as html
import generate_upload_component as guc

def generate_layout():
    return html.Div(children = [
        html.Header(
            children = "My Dash application"
            ),
        generate_body()#,
        # html.Footer(
        #     children = "FOOTER")
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
                "C'est ici qu'on va upload",
                guc.generate_upload_component()
                ])                  
        

def generate_right_div():
        return html.Div(
            className = 'body_div',
            id = 'body_right')                  
        

#external_stylesheets = ['https://codepen.io/chriddyp/pen/bWLwgP.css']
#app = dash.Dash(__name__,external_stylesheets = external_stylesheets)
app = dash.Dash(__name__)
app.layout = generate_layout()


if __name__ == '__main__':
    app.run_server(debug=True)