$(function() {
    attachListeners()
});

const splashScreenHTML = `
        <div id="welcome-splash">
            <div id="welcome-logo">
                <a id="logo-link" href="/">penda</a>
                <div id="welcome-options">
                    <div class="btn-group" role="group" aria-label="Button group for time entries">
                        <form class="button_to" method="get" action="/businesses/new"><input class="btn choices-btn1" type="submit" value="business user" kl_vkbd_parsed="true"></form>
                        <form class="button_to" method="get" action="/clients/new"><input class="btn choices-btn2" type="submit" value="standard user" kl_vkbd_parsed="true"></form>
                    </div> <!-- btn-group -->
                </div> <!-- .welcome-options -->
            </div> 
        </div>
    `

function attachListeners() {
    $('.js-signup').on('click', function (e) {
        e.preventDefault();       
        $('#js-ContentBox').html("");
        $('#js-ContentBox').html(splashScreenHTML);
    });
}

