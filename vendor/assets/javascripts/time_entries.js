$(function () { 
    $('.clock').FlipClock();
});

var clock = new FlipClock($('.clock'), 100, {

    // Create a minute counter
    clockFace: 'MinuteCounter',

    // The onStart callback
    onStart: function() {
        // Do something
    },

    // The onStop callback
    onStop: function() {
        // Do something
    },

    // The onReset callback
    onReset: function() {
        // Do something
    }
});