import os
import requests
import socket

from flask import Flask
from waitress import serve

app = Flask(__name__)

HOSTNAME = socket.gethostname()
API_URL = os.environ.get('API_URL')

@app.route('/')
def home():
    html = f'<h1>Hello, World from {HOSTNAME}!</h1>'

    if API_URL:
        api_content = requests.get(API_URL).content.decode('utf-8')
        html = f'{html}{api_content}'

    return html

@app.route('/api')
def api():
    html = f'<p>Calling {HOSTNAME}</p>'

    if API_URL:
        api_content = requests.get(API_URL).content.decode('utf-8')
        html = f'{html}{api_content}'

    return html

if __name__ == '__main__':
    host = os.environ.get('HOST', '0.0.0.0')
    port = os.environ.get('PORT', 8000)

    print(f'Starting server on {host}:{port}')
    serve(app, host=host, port=port)