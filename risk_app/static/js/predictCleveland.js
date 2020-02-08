$(function() {
    $('button').click(function() {
        surveyData=$('form').serialize();
        console.log(surveyData);
        $.ajax({
            url:'/resultCleveland',
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