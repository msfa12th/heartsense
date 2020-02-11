#importing libraries
from flask import Flask, jsonify, render_template, request
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import *
from sqlalchemy.ext.automap import automap_base
from sklearn.svm import *
from sklearn.externals import joblib

import os
import json
import numpy as np
import pickle

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
CardioTrain = Base.classes.heart_cardio_train
Heart_ml_cleveland = Base.classes.heart_ml_cleveland
Heart_patient = Base.classes.heart_patient


@app.route("/")
@app.route("/index")
@app.route("/cleveland")
def index():
    """Return the homepage."""
    return render_template("index.html", )

@app.route('/predict')
def predict():
    return render_template("predictCardioRisk.html",status="predict" )

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


@app.route('/resultCR',methods = ['POST'])
def resultCR():
    if request.method == 'POST': 
        patient_info = request.form.to_dict()
   
        # get 9 input values
        int_features = [int(x) for x in request.form.values()]

        # reorder the 7 features
        feature_order = [1,4,5,6,0,3,2]
        myFeatures = [int_features[i] for i in feature_order]

        #calculate BMI 703*lbs/in2
        myFeatures[6]=round(703*myFeatures[5]/(myFeatures[6]*myFeatures[6]),2)

        final_features = [np.array(myFeatures)]
        # loaded_model = joblib.load(open("svc_best_model_cardio.pkl","rb"))
        loaded_model = joblib.load(open("model_svc.pkl","rb"))
        result = loaded_model.predict(final_features)

        myList = ['Empty','Normal (< 200)', 'Borderline High (200-239)', 'High (240 and higher)']
        cholesterolValue = int(patient_info['cholesterol'])

        if int(result)==1:
            prediction='Heart Disease Risk'
        else:
            prediction='NOT a Heart Disease Risk'
            
        # return render_template("predictCardioRisk.html",prediction=result,)
        return render_template("predictCardioRisk.html",status="results",prediction=prediction,result=result[0],patient=patient_info,myBMI=myFeatures[6],myChol=myList[cholesterolValue])




if __name__ == '__main__':
    app.run()