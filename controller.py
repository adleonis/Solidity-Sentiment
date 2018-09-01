#!/usr/bin/env python3
''' 
CONTROLLER
**************************************************************************
Main site Controller.  Uses flask to throw templates, 


'''

from flask import Flask, jsonify, render_template, request, redirect, url_for, flash
#from flask_login import LoginManager, login_required, current_user
#from flask_bootstrap import Bootstrap
#import flask_login
import os


#import model
#import view
import datetime
import time
#import orm
#import scraper

#login_manager = LoginManager()

app = Flask(__name__)
#app.secret_key = os.urandom(24)
#Bootstrap(app)

@app.template_filter('BMk')
def translate_followers(s):
    if s > 999999999:
        return str(round(s/1000000000,1))+'B'
    elif s > 999999:
        return str(round(s/1000000,1))+'M'
    elif s > 999:
        return str(round(s/1000,1))+'k'
    else:
        return s

@app.template_filter('ctime')
def timectime(s):
    return time.ctime(float(s)) # datetime.datetime.fromtimestamp(s)


@app.context_processor
def override_url_for():
    ''' 
    This code is by Eric Buckley from http://flask.pocoo.org/snippets/40/
    It updates your static files everytime the browser refreshes so styles are up to date, not busted by browser cache
    '''
    return dict(url_for=dated_url_for)

def dated_url_for(endpoint, **values):
    ''' 
    This code is by Eric Buckley from http://flask.pocoo.org/snippets/40/
    It updates your static files everytime the browser refreshes so styles are up to date, not busted by browser cache
    '''
    if endpoint == 'static':
        filename = values.get('filename', None)
        if filename:
            file_path = os.path.join(app.root_path,
                                     endpoint, filename)
            values['q'] = int(os.stat(file_path).st_mtime)
    return url_for(endpoint, **values)


@app.route('/', methods=['GET', 'POST'])
def show_app():
    ''' 
    ..Main website page -- form to input bid
    '''
    if request.method == 'GET':
        # This is an HTTP get request.
        return render_template('front.html')


@app.route('/about', methods=['GET', 'POST'])
def about():
    ''' 
    ..Main website about page -- product info
    '''
    if request.method == 'GET':
        # This is an HTTP get request.
        return render_template('about.html')

@app.route('/front', methods=['GET', 'POST'])
def front():
    ''' 
    ..Main app front page -- message display and consumption
    '''
    if request.method == 'GET':
        # This is an HTTP get request.
        return render_template('front.html')





if __name__ == '__main__':
    app.run(host='127.0.0.1', port=5000, debug=True)

