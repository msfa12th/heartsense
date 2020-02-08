from flask import Flask, request
from flask import Flask, jsonify, render_template, request
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import *

# import sqlalchemy
from sqlalchemy.ext.automap import automap_base
import os
import json

app = Flask(__name__)

def get_env_variable(name):
    try:
        return os.environ[name]
    except KeyError:
        message = "Expected environment variable '{}' not set.".format(name)
        raise Exception(message)

# the values of those depend on your setup
POSTGRES_URL = get_env_variable("POSTGRES_URL")
POSTGRES_USER = get_env_variable("POSTGRES_USER")
POSTGRES_PW = get_env_variable("POSTGRES_PW")
POSTGRES_DB = get_env_variable("POSTGRES_DB")

DB_URL = 'postgresql+psycopg2://{user}:{pw}@{url}/{db}'.format(user=POSTGRES_USER,pw=POSTGRES_PW,url=POSTGRES_URL,db=POSTGRES_DB)

app.config['SQLALCHEMY_DATABASE_URI'] = DB_URL
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False # silence the deprecation warning

db = SQLAlchemy(app)

# reflect an existing database into a new model
Base = automap_base()

# reflect the tables
Base.prepare(db.engine, reflect=True)

# Save references to each table
Behaviors = Base.classes.heart_behavior_risk
CardioTrain = Base.classes.heart_cardio_train
Heart_ml_cleveland = Base.classes.heart_ml_cleveland
Heart_mortality = Base.classes.heart_mortality
Heart_nhis = Base.classes.heart_nhis
Heart_patient = Base.classes.heart_patient


@app.route("/")
def index():
    """Return the homepage."""
    return render_template("index.html", )

@app.route('/predict')
def predict():
    return render_template("predictCardioRisk.html", )

@app.route('/cleveland')
def cleveland():
    return render_template("predictCleveland.html", )

@app.route('/visual')
def visual():
    return render_template("tableau.html", )

@app.route('/team')
def team():
    return render_template("team.html", )

@app.route('/data')
def data():
    results = db.session.query(Behaviors.Year, func.count(Behaviors.id).label('numRows')).group_by(Behaviors.Year).order_by(Behaviors.Year).all()

    # for s in results:
    #     output.append({'Year' : s['Year'],'NumRows' : s['numRows']})
  
    # return jsonify(results)
    return render_template("index.html", rows=results)


@app.route('/hello')
def hello():
    return "Hello World!"

@app.route("/bootstrap")
def boostrap():
    """Return the homepage."""
    return render_template("index-bs3.html", )


@app.route("/bkp")
def bkp():
    """Return the homepage."""
    return render_template("index-bkp.html", )

@app.route('/patientinfo')
def get_patientinfo():
    # patient_info = Heart_patient("Doctor Strange", "Scott Derrickson", "2016")  
    # db_session.add(doctor_strange) 
    return render_template("index.html")
 


@app.route('/name/<name>')
def hello_name(name):
    return "Hello {}!".format(name)

@app.route("/survey")
# @app.route('/survey', methods=['GET'])
def get_survey():
    myAge = request.args.get('age')
    myGender = request.args.get('gender')
    myHeight = request.args.get('height')
    myWeight = request.args.get('weight')
    myAPhi = request.args.get('aphi')
    myAPlo = request.args.get('aplo')
    myCholestorol = request.args.get('cholestorol')
    myGlucose = request.args.get('glucose')
    mySmoker = request.args.get('smoke')
    myAlcohol = request.args.get('alcohol')
    myActive = request.args.get('active')
    return "Age : {}, Gender: {}, Height: {}, Weight: {}".format(myAge,myGender,myHeight,myWeight)


# db.session.add(Heart_patient,myAge)
@app.route("/details")
def get_book_details():
    #  how to : {route}?author=<str>&published=<str>
    author=request.args.get('author')
    published=request.args.get('published')
    return "Author : {}, Published: {}".format(author,published)

if __name__ == '__main__':
    app.run()