from flask import Flask, request
from flask import Flask, jsonify, render_template, request
from sqlalchemy.ext.automap import automap_base
from flask_sqlalchemy import SQLAlchemy
import os

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
Heart_behavior_risk = Base.classes.heart_behavior_risk
Heart_cardio_train = Base.classes.heart_cardio_train
Heart_ml_cleveland = Base.classes.heart_ml_cleveland
Heart_mortality = Base.classes.heart_mortality
Heart_nhis = Base.classes.heart_nhis
Heart_patient = Base.classes.Heart_patient
Test_doctors = Base.classes.doctors
Test_patients = Base.classes.patients

@app.route("/")
def index():
    """Return the homepage."""
    return render_template("index.html")

@app.route('/hello')
def hello():
    return "Hello World!"

@app.route('/test')
def test():
    results = db.session.query(Test_doctors).all()

    all_data = []
    for specialty, taking_patients in results:
        doctor_list = {}
        doctor_list["specialty"] = specialty
        doctor_list["taking_patients"] = taking_patients
        all_data.append(doctor_list)
    
    return jsonify(all_data)
    
@app.route("/names")
def names():
    """Return a list of sample names."""

    # Use Pandas to perform the sql query
    stmt = db.session.query(Test_patients).statement
    df = pd.read_sql_query(stmt, db.session.bind)

    # Return a list of the column names (sample names)
    return jsonify(list(df.columns)[2:])

# @app.route("/risk")
# def sample_risk(year):
#     """Return the <sample> number of records from hear_behavior_risk table."""
#     sel = [
#         Heart_behavior_risk.year,
#         Heart_behavior_risk.ETHNICITY,
#         Heart_behavior_risk.GENDER,
#         Heart_behavior_risk.AGE,
#         Heart_behavior_risk.LOCATION,
#         Heart_behavior_risk.BBTYPE,
#         Heart_behavior_risk.WFREQ
#     ]

#     #results = db.session.query(Heart_behavior_risk).filter(Heart_behavior_risk."Year" == 2011).all()
#     # results = db.session.query(*sel).filter(Samples_Metadata.sample == sample).all()

#     # Create a dictionary entry for each row of metadata information
#     sample_metadata = {}
#     for result in results:
#         sample_metadata["sample"] = result[0]
#         sample_metadata["ETHNICITY"] = result[1]
#         sample_metadata["GENDER"] = result[2]
#         sample_metadata["AGE"] = result[3]
#         sample_metadata["LOCATION"] = result[4]
#         sample_metadata["BBTYPE"] = result[5]
#         sample_metadata["WFREQ"] = result[6]

#     # print(sample_metadata)
#     return jsonify(sample_metadata)

@app.route('/name/<name>')
def hello_name(name):
    return "Hello {}!".format(name)

@app.route("/details")
def get_book_details():
    author=request.args.get('author')
    published=request.args.get('published')
    return "Author : {}, Published: {}".format(author,published)

if __name__ == '__main__':
    app.run()