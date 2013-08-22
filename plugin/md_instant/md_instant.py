# -*- coding: utf-8 -*-

from BaseHTTPServer import BaseHTTPRequestHandler, HTTPServer
import cgi
import threading
import sys
import os
import json
from markdown import markdown

import ws

markdown_options = ['extra', 'codehilite']
current_dir = os.path.dirname(os.path.abspath(__file__))

class MyHandler(BaseHTTPRequestHandler):

    def do_GET(self):
        self.send_response(200)
        self.end_headers()
        f = open(current_dir+'/index.html', 'r')
        data = f.read()
        self.wfile.write(data)
        f.close()

def sendall(data):
    html = markdown('\n'.join(data).decode('utf-8'), markdown_options)
    threading.Thread(target=ws.sendall, args=(json.dumps(html),)).start()

def startbrowser():
    url = 'http://localhost:7000/'
    if sys.platform.startswith('darwin'):
        os.system('open -g '+url)
    elif sys.platform.startswith('win'):
        os.system('start '+url)
    else:
        os.system('xdg-open '+url)

t_server = None
t_ws = None

def startserver():
    s = HTTPServer(('', 7000), MyHandler)
    s.serve_forever()

def stopserver():
    t_server._Thread__stop()
    t_ws._Thread__stop()

def main():
    global t_server, t_ws
    t_ws = threading.Thread(target=ws.main)
    t_server = threading.Thread(target=startserver)
    t_ws.start()
    t_server.start()
