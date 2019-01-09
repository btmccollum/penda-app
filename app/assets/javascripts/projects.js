// # Place all the behaviors and hooks related to the matching controller here.
// # All this logic will automatically be available in application.js.
// # You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready(function() {
   
//    $("a.load-comments").on("click", function(e) {
    // low level with .ajax : 
    // $.ajax({
    //     method: "GET",
    //     url: this.href 
    // }).done(function(response) {
    //     // #get the response
    //     // console.log(data);
    //     $("div.p-comments").append(response)
    // }).error(function(notNeeded) {
    //     alert("Oops! Something went wrong.")
    // });
    // e.preventDefault();
    // });

    // // refactored to this with AJAX/jquery:
    // $.get(this.href).done(function(response){
    //     $("div.p-comments").append(response)
    // });
    // e.preventDefault();
    // });

    // refactored for JSON if using JSON:
    // $.get(this.href).done(function(json) {
    //     // $("div.p-comments").html("") //empty the content in the div
    //     let $ul = $("div.p-comments ul")
    //     $ul.html("")
    //     json.forEach(function(comment) {
    //         $ul.append(`<li>${comment.content}<.li>`)
    //     })  
    // })

    
    $("#new_comment").on("submit", function(e) {
        e.preventDefault();
        let $form = $(this);
        let action = $form.attr("action") + ".json"
        let params = $form.serialize();

        $.post(action, params)
        .done(function(json){
            //getting back a js object of the item just created
            let $ul = $("#comment-list")
            //mimicking the rails list style
            $("#comment_content").val("");
            $ul.prepend(`<li class="list-group-item"><strong>${json['user']['username']}</strong> says: ${json['comment']['content']} | <strong>Posted at:</strong> Just a moment ago... <a data-confirm="Are you sure?" class="btn-sm btn-danger pull-right" rel="nofollow" data-method="delete" href="/comments/${json['comment']['id']}">X</a></li>`)
        }).fail(function(response){
            console.log("Something went wrong.", response);
        });
    });
});
