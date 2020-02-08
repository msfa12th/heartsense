

function cardioPredict(event) {
    console.log(document.getElementById("myAge").value);
    console.log(document.getElementById("myGender").value);
    console.log(document.getElementById("myHeight").value);
    console.log(document.getElementById("myWeight").value);
    console.log(document.getElementById("myAPhi").value);
    console.log(document.getElementById("myAPlo").value);
    console.log(document.getElementById("myCholesterol").value);
    console.log(document.getElementById("myGlucose").value);
    console.log(document.getElementById("mySmoker").value);
    console.log(document.getElementById("myAlcohol").value);
    console.log(document.getElementById("myActivity").value);


    url="/survey?"
    url=url + "age=" + document.getElementById("myAge").value;
    url=url + "&gender=" + document.getElementById("myGender").value;
    url=url + "&height=" + document.getElementById("myHeight").value;
    url=url + "&weight=" + document.getElementById("myWeight").value;
    url=url + "&aphi=" + document.getElementById("myAPhi").value;
    url=url + "&aplo=" + document.getElementById("myAPlo").value;
    url=url + "&cholesterol=" + document.getElementById("myCholesterol").value;
    url=url + "&glucose=" + document.getElementById("myGlucose").value;
    url=url + "&smoker=" + document.getElementById("mySmoker").value;
    url=url + "&alcohol=" + document.getElementById("myAlcohol").value;
    url=url + "&activity=" + document.getElementById("myActivity").value;

    console.log(url);

    const Http = new XMLHttpRequest();
    Http.open("POST", url,true);

    return;
  }

