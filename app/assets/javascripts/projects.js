// # Place all the behaviors and hooks related to the matching controller here.
// # All this logic will automatically be available in application.js.
// # You can use CoffeeScript in this file: http://coffeescript.org/
$(function() {
    addListeners()
});


function addListeners() {
	$('a.js-AllProjects').on('click', function (e) {
        e.preventDefault();
		getProjects();
    });

    $('a.js-ActiveProjects').on('click', function (e) {
        e.preventDefault();
        const params = { "status": "active" }
		getProjects(params);
    });

    $('a.js-CompletedProjects').on('click', function (e) {
        e.preventDefault();
        params = { "status": "completed" }
		getProjects(params);
	});
}

function getProjects(query) {
    $.ajax({
        url: '/dashboard',
        type: "GET",
        dataType: 'json',
        data: query
    }).done(function(data) {
        $('.js-Projects').html("");
        data['projects'].forEach(function(project) {
            const addedProject = new Project(project);
            console.log(addedProject);
            $('.js-Projects').prepend(addedProject.postHTML());
        });
    });
}

function capitalizeFirstLetter(word) {
    return word.charAt(0).toUpperCase() + word.slice(1)    
}

class Project {
    constructor(obj) {
        this.id = obj.id
        this.client_id = obj.client_id
        this.business_id = obj.business_id
        this.title = obj.title
        this.created_at = obj.created_at
        this.updated_at = obj.updated_at
        this.status = obj.status
        this.comments =  new Array(obj.comments)
        this.time_entries = new Array(obj.time_entries)
    }
}

// return HTML entry for dashboard page
Project.prototype.postHTML = function() {
    return (`
        <li class="list-group-item"><strong>Title:</strong> <a href="/projects/${this.id}">${this.title}</a> | <strong>Total Time:</strong> 0.0 Seconds  | <strong>Last Update:</strong> ${this.updated_at} | <strong>Status:</strong> ${capitalizeFirstLetter(this.status)}</li>
    `)
}

// Project.prototype.getTimeEntries = () => {
//     $.get(action, params)
//         .done(function(json){
//             //getting back a js object of the item just created
//             let $ul = $("#comment-list")
//             //clearing user submission from text area
//             $("#comment_content").val("");
//             //mimicking the rails list style
//             $ul.prepend(`<li class="list-group-item"><strong>${json['user']['username']}</strong> says: ${json['comment']['content']} | <strong>Posted at:</strong> Just a moment ago... <a data-confirm="Are you sure?" class="btn-sm btn-danger pull-right buttonJS" rel="nofollow" data-method="delete" href="/comments/${json['comment']['id']}">X</a></li>`)
//         }).fail(function(response){
//             console.log("Something went wrong.", response);
//     });
// }

Project.prototype.getComments = () => {
    $("#new_comment").on("submit", function(e) {
        e.preventDefault();
        let $form = $(this);
        let action = $form.attr("action") + ".json"
        let params = $form.serialize();
    
        $.post(action, params)
            .done(function(json){
                //getting back a js object of the item just created
                let $ul = $("#comment-list")
                //clearing user submission from text area
                $("#comment_content").val("");
                //mimicking the rails list style
                $ul.prepend(`<li class="list-group-item"><strong>${json['user']['username']}</strong> says: ${json['comment']['content']} | <strong>Posted at:</strong> Just a moment ago... <a data-confirm="Are you sure?" class="btn-sm btn-danger pull-right buttonJS" rel="nofollow" data-method="delete" href="/comments/${json['comment']['id']}">X</a></li>`)
            }).fail(function(response){
                console.log("Something went wrong.", response);
        });
    });
}