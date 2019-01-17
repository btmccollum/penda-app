function logInUser() {
    $('form').submit(function(e) {
        e.preventdefault();
        alert('hi');
    })
}