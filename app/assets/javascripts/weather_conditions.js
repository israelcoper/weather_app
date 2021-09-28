$(document).ready(() => {
    $('form').on('submit', e => {
        const postcode = $('#postcode');

        if (postcode.val() == "") {
            alert("Please enter postcode.");
        } else {
            $.ajax({
                url: "/weather_conditions",
                method: 'POST',
                data: { postcode: postcode.val() },
                success: data => {
                    console.log(data);
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
