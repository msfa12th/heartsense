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
Behaviors = Base.classes.heart_behavior_risk
CardioTrain = Base.classes.heart_cardio_train
Heart_ml_cleveland = Base.classes.heart_ml_cleveland
Heart_mortality = Base.classes.heart_mortality
Heart_nhis = Base.classes.heart_nhis
Heart_patient = Base.classes.heart_patient


@app.route("/")
@app.route("/index")
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

@app.route("/survey", methods=['POST'])
# @app.route('/survey', methods=['GET'])
# @app.route("/survey")
def get_surveyInput():
    myAge = request.form['age']
    myGender = request.form['gender']
    myHeight = request.form['height']
    myWeight = request.form['weight']
    myAPhi = request.form['ap_hi']
    myAPlo = request.form['ap_lo']
    myCholestorol = request.form['cholestorol']
    myGlucose = request.form['glucose']
    mySmoker = request.form['smoke']
    myAlcohol = request.form['alcohol']
    myActivity = request.form['active']
    return "Age : {}, Gender: {}, Height: {}, Weight: {}".format(myAge,myGender,myHeight,myWeight)
    # return("Hello World")

    # return json.dumps({'status':'OK','age':myAge,'gender':myGender,'height':myHeight,
    #     'weight':myWeight,'aphi':myAPhi, 'aplo':myAPlo,'cholesterol':myCholestorol,
    #     'glucose':myGlucose,'smoke':mySmoker,'alcohol':myAlcohol,'active':myActivity})

# db.session.add(Heart_patient,myAge)



@app.route("/details")
def get_book_details():
    #  how to : {route}?author=<str>&published=<str>
    author=request.args.get('author')
    published=request.args.get('published')
    return "Author : {}, Published: {}".format(author,published)

#prediction function

def ValueClevelandPredictor(to_predict_list):
    to_predict = np.array(to_predict_list).reshape(1,13)
    # loaded_model = pickle.load(open("knn_best_model.pkl","rb"))
    loaded_model = joblib.load(open("knn_best_model.pkl","rb"))
    result = loaded_model.predict(to_predict)
    return result[0]

def ValueCardioRiskPredictor(to_predict_list):
    to_predict = np.array(to_predict_list).reshape(1,15)
    # loaded_model = pickle.load(open("svc_best_model_cardio.pkl","rb"))
    loaded_model = joblib.load(open("svc_best_model_cardio.pkl","rb"))
    result = loaded_model.predict(to_predict)
    return result[0]

@app.route('/resultCRbkp',methods = ['POST'])
def resultCRbkp():
    if request.method == 'POST':
        to_predict_list = request.form.to_dict()
        to_predict_list=list(to_predict_list.values())
        to_predict_list = list(map(int, to_predict_list))
        result = ValueCardioRiskPredictor(to_predict_list)
        
        if int(result)==1:
            prediction='Presence of heart disease'
        else:
            prediction='Absence of heart disease'
            
        return render_template("resultCardioRisk.html",prediction=prediction)

@app.route('/resultCR',methods = ['POST'])
def resultCR():
    if request.method == 'POST': 
        patient_info = request.form.to_dict()
   
        # get 9 input values
        int_features = [int(x) for x in request.form.values()]
        # int_features = [55,1,65,170,125,78,1,1,1]

        # convert input to 15 features
        feature_order = [4,5,0,3,2,8,8,6,6,6,1,1,7,7,7]
        myFeatures = [int_features[i] for i in feature_order]

        #calculate BMI 703*lbs/in2
        myFeatures[4]=round(703*myFeatures[3]/(myFeatures[4]*myFeatures[4]),2)

        # myFeatures[4]=703*myFeatures[3]/(myFeatures[4])
        
        # split active feature
        myFeatures[5]= 0 if myFeatures[5] > 0 else 1

        # split cholesterol feature
        myFeatures[7]= 1 if (myFeatures[7]==1) else 0
        myFeatures[8]= 1 if (myFeatures[8]==2) else 0
        myFeatures[9]= 1 if (myFeatures[9]==3) else 0

        # split gender feature
        myFeatures[10]= 1 if (myFeatures[10]==1) else 0
        myFeatures[11]= 1 if (myFeatures[11]==2) else 0

       # split glucose feature
        myFeatures[12]= 1 if (myFeatures[12]==1) else 0
        myFeatures[13]= 1 if (myFeatures[13]==2) else 0
        myFeatures[14]= 1 if (myFeatures[14]==3) else 0

        final_features = [np.array(myFeatures)]
        loaded_model = joblib.load(open("svc_best_model_cardio.pkl","rb"))
        result = loaded_model.predict(final_features)

        myList = ['Empty','Normal (< 200)', 'Borderline High (200-239)', 'High (240 and higher)']
        cholesterolValue = int(patient_info['cholesterol'])

        if int(result)==1:
            prediction='Presence of heart disease'
        else:
            prediction='Absence of heart disease'
            
        # return render_template("predictCardioRisk.html",prediction=result,)
        return render_template("resultCardioRisk.html",prediction=prediction,result=result[0],patient=patient_info,myBMI=myFeatures[4],myChol=myList[cholesterolValue])


@app.route('/resultClevelandBkp',methods = ['POST'])
def resultClevelandBkp():
    if request.method == 'POST':
        to_predict_list = request.form.to_dict()
        to_predict_list=list(to_predict_list.values())
        to_predict_list = list(map(int, to_predict_list))
        result = ValueClevelandPredictor(to_predict_list)
        
        if int(result)==1:
            prediction='Presence of heart disease'
            alert="green"
        else:
            prediction='Absence of heart disease'
            alert="red"
            
        return render_template("predictCleveland.html",prediction=prediction,alert=alert)

@app.route('/resultCleveland',methods = ['POST'])
def resultCleveland():
    if request.method == 'POST':    
        # get 9 input values
        int_features = [int(x) for x in request.form.values()]
        int_features = [55,1,65,170,125,78,1,1,1]

        # convert input to 15 features
        feature_order = [4,5,0,3,2,8,8,6,6,6,1,1,7,7,7]
        myFeatures = [int_features[i] for i in feature_order]

        #calculate BMI 703*lbs/in2
        myFeatures[4]=703*myFeatures[3]/(myFeatures[4]*myFeatures[4])
        # myFeatures[4]=703*myFeatures[3]/(myFeatures[4])
        
        # split active feature
        myFeatures[5]= 0 if myFeatures[5] > 0 else 1

        # split cholesterol feature
        myFeatures[7]= 1 if (myFeatures[7]==1) else 0
        myFeatures[8]= 1 if (myFeatures[8]==2) else 0
        myFeatures[9]= 1 if (myFeatures[9]==3) else 0

        # split gender feature
        myFeatures[10]= 1 if (myFeatures[10]==1) else 0
        myFeatures[11]= 1 if (myFeatures[11]==2) else 0

       # split glucose feature
        myFeatures[12]= 1 if (myFeatures[12]==1) else 0
        myFeatures[13]= 1 if (myFeatures[13]==2) else 0
        myFeatures[14]= 1 if (myFeatures[14]==3) else 0

        final_features = [np.array(myFeatures)]
        loaded_model = joblib.load(open("svc_best_model_cardio.pkl","rb"))
        result = loaded_model.predict(final_features)

        if int(result)==1:
            prediction='Presence of heart disease'
        else:
            prediction='Absence of heart disease'
            
        return render_template("predictCardioRisk.html",prediction=prediction)




if __name__ == '__main__':
    app.run()