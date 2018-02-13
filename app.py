from flask import Flask
from redis import Redis, RedisError
import os
import socket

import pandas
import numpy
import psycopg2
import cvxopt
import pyodbc

# Connect to Redis
redis = Redis(host="redis", db=0, socket_connect_timeout=2, socket_timeout=2)

app = Flask(__name__, static_url_path='/app')

@app.route("/")
def hello():
    try:
        visits = redis.incr("counter")
    except RedisError:
        visits = "<i>cannot connect to Redis, counter disabled</i>"

    html = "<div style='margin-top:5%;margin-bottom:0;margin-left:auto;margin-right:auto;text-align:center;'><h3>Hello {name}!</h3>" \
           "<b>Hostname:</b> {hostname}<br/>" \
           "<b>Visits:</b> {visits} <br/><hr>" \
	   "<b style='color:green;'>Pandas -v: " + str(pandas.__version__) + "</b></br>" \
           "<b style='color:green;'>Numpy -v: " + str(numpy.__version__) + "</b></br>" \
           "<b style='color:green;'>psycopg2 (unix + Python 3 friendly) -v: " + str(psycopg2.__version__) + "</b></br>" \
           "<b style='color:green;'>cvxopt -v: " + str(cvxopt.__version__) + "</b></br>" \
           "<b style='color:green;'>pyodbc -v: " + str(pyodbc.version) + "</b><hr> <img style='width:50%;height:50%' src='/app/logo_red.svg'></div>"	
    return html.format(name=os.getenv("NAME", "world"), hostname=socket.gethostname(), visits=visits)

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=80)
