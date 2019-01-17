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

const loginHTML = `
        <div id="welcome-splash-mini">
        <div id="welcome-logo-mini">
            <a id="logo-link" href="/">penda</a>
        </div> 
        </div>

        <p>
        Log in with:
        <a href="/auth/facebook"><span class="fa-stack fa-fw"><i class="fa fa-square-o fa-stack-2x"></i><i class="fa fa-facebook-square fa-stack-1x"></i></span></a>
        <a href="/auth/google_oauth2"><span class="fa-stack fa-fw"><i class="fa fa-square-o fa-stack-2x"></i><i class="fa fa-google fa-stack-1x"></i></span></a><br>
        </p>

        <form action="/sessions" accept-charset="UTF-8" method="post"><input name="utf8" type="hidden" value="✓" kl_vkbd_parsed="true"><input type="hidden" name="authenticity_token" value="iW17dHvy/ZdlgbqmdADloBJxxkgqYBKYLn0zAfSGX1rBtBquYx/8lli/wBurFeh9IScWZnDxkjIwqm+0jhwTRQ==" kl_vkbd_parsed="true">

        <div class="form-group col-md-4 mx-auto">
            <strong>Email:</strong><br>
            <input type="email" name="email" id="email" value="" autofocus="autofocus" autocomplete="email" class="form-control" kl_vkbd_parsed="true">
        </div>

        <div class="form-group col-md-4 mx-auto">
            <strong>Password:</strong><br>
            <input type="password" name="password" id="password" value="" autofocus="autofocus" autocomplete="current-password" class="form-control" kl_vkbd_parsed="true">
        </div>

        <div class="actions">
        <p><input type="submit" name="commit" value="Log In" class="btn btn-primary" data-disable-with="Log In" kl_vkbd_parsed="true"></p>
        </div>
        </form>
    `


function attachListeners() {
    $('.js-signup').on('click', function (e) {
        e.preventDefault();       
        $('#contentBox').html("");
        $('#contentBox').html(splashScreenHTML);
    });

    $('.js-login').on('click', function (e) {
        e.preventDefault();   
        $('#contentBox').html("");
        $('#contentBox').html(loginHTML);
    });
}