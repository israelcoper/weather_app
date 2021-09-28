$(document).ready(() => {
    $('form').on('submit', e => {
        const postcode = $('#postcode');

        if (postcode.val() == "") {
            alert("Please enter postcode.");
        } else {
            $('#spinner').removeClass('d-none');
            $('#result').addClass('d-none');
            $('#result').html('');

            $.ajax({
                url: "/weather_conditions",
                method: 'POST',
                data: { postcode: postcode.val() },
                success: data => {
                    $('#spinner').addClass('d-none');
                    $('#result').removeClass('d-none');

                    let template;

                    if (data.valid) {
                        const { city, country, temperature, date_time: dateTime, weather_condition: condition } = data;
                        template = HandlebarsTemplates['weather_conditions/result']({ city, country, temperature, dateTime, condition });
                    } else {
                        const { message } = data;
                        template = HandlebarsTemplates['weather_conditions/invalid']({ message });
                    }

                    $(template).appendTo('#result');
                },
                error: error => {
                    console.log(error);
                }
            });

            postcode.val(''); // reset form
        }

        e.preventDefault();
    });
});
