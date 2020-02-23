#importing libraries
from flask import Flask, jsonify, render_template, request
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import *
from sqlalchemy.ext.automap import automap_base

import os
import numpy as np
import re

import keras
import tensorflow as tf
from keras.models import load_model
from keras import backend as K




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

Best_model = load_model('NN_model.h5')

Best_model._make_predict_function()
graph = tf.get_default_graph()

@app.route("/")
@app.route("/index")
@app.route("/cleveland")
def index():
    """Return the homepage."""
    return render_template("index.html", )

@app.route('/predict')
def predict():
    return render_template("predictCardioRisk.html",status="predict" )


@app.route('/machineln')
def machine():
    return render_template("machinelearning.html" )    

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
def resultCRNN():
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
        final_shape = np.reshape(final_features,(1,-1))
        
        global graph
        with graph.as_default():
            result = Best_model.predict(final_shape)

        result_percent = np.round(result*100,2)
        result_string = re.sub('[\[\]]','',np.array_str(result_percent))  + '%'

        myList = ['Empty','Normal (< 200)', 'Borderline High (200-239)', 'High (240 and higher)']
        cholesterolValue = int(patient_info['cholesterol'])

        if int(result_percent)>=65:
            prediction='High Heart Disease Risk'
            risk=3

        elif int(result_percent)>=35:
            prediction='Moderate Heart Disease Risk'
            risk=2

        else:
            prediction='Low Heart Disease Risk'
            risk=1
            
        return render_template("predictCardioRisk.html",status="results",risk=risk,prediction=prediction,result=result_string,patient=patient_info,myBMI=myFeatures[6],myChol=myList[cholesterolValue])




if __name__ == '__main__':
    app.run()