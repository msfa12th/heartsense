$(function() {
    $('button').click(function() {
        surveyData=$('form').serialize();
        console.log(surveyData);
        $.ajax({
            url:'/resultCR',
            data: $('form').serialize(),
            type: 'POST',
            success: function(response) {
                console.log(response);
            },
            error: function(error) {
                console.log(error);
            },
        });
    });
});

// function cardioPredict() {

//     url="/survey?"
//     url=url + "age=" + document.getElementById("myAge").value;
//     url=url + "&gender=" + document.getElementById("myGender").value;
//     url=url + "&height=" + document.getElementById("myHeight").value;
//     url=url + "&weight=" + document.getElementById("myWeight").value;
//     url=url + "&aphi=" + document.getElementById("myAPhi").value;
//     url=url + "&aplo=" + document.getElementById("myAPlo").value;
//     url=url + "&cholesterol=" + document.getElementById("myCholesterol").value;
//     url=url + "&glucose=" + document.getElementById("myGlucose").value;
//     url=url + "&smoker=" + document.getElementById("mySmoker").value;
//     url=url + "&alcohol=" + document.getElementById("myAlcohol").value;
//     url=url + "&activity=" + document.getElementById("myActivity").value;

//     console.log(url);

//     const Http = new XMLHttpRequest();
//     Http.open("POST", url,true);
//     Http.send();

//     return;
//   }

