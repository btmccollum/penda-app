// # Place all the behaviors and hooks related to the matching controller here.
// # All this logic will automatically be available in application.js.
// # You can use CoffeeScript in this file: http://coffeescript.org/
$(function() {
    addListeners()
});


function addListeners() {
    //make use of event delegation to capture link
    $('.js-Projects').on('click', 'a', function(e) {
        e.preventDefault();
        loadProject(this);
    }); 

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
 
    $('body').on('click', '#new_comment input.btn', () => {
        if (currentProject !== undefined) {
            bindCommentsForm();
        }
    });

    $('body').on('click', '.js-NewTimeEntry', function(e) {
        if (currentProject !== undefined) {
            e.preventDefault();
            bindTimeEntryForm();
        }
    });

    $('body').on('click', '.js-AllTimeEntries', function(e) {
        if (currentProject !== undefined) {
            e.preventDefault();
            bindAllTimeEntries();
        }
    });
}

let currentProject;

function getProjects(query) {
    $.ajax({
        url: '/dashboard',
        type: "GET",
        dataType: 'json',
        data: query
    }).done(function(data) {
        $('.js-Projects').html("");
        data['projects'].forEach(function(project) {
            currentProject = new Project(project);
            $('.js-Projects').prepend(currentProject.projectsListHTML());
        });
    });
}

// necessary to add JS back to comments form when the projects show view is rendered after ajax get
function bindCommentsForm() {
    $('#new_comment').submit(function(e) {
        e.preventDefault();
        currentProject.createComment();
    });
}

function bindTimeEntryForm() {
    currentProject.newTimeEntryForm();
}

function bindAllTimeEntries() {
    currentProject.timeEntriesIndex();
}

function loadProject(data) {
    // create a get request using the id fetched from the project link's dataset
    $.get('/projects/' + data.dataset.id + '.json')
        .done(function(project) {
            currentProject = new Project(project['project']);
            $('.js-Content').html("")
            // using a get request to fetch just the .js-Content section from the projects show page to render on top of current page
            $('.js-Content').load(`/projects/${currentProject.id}.html .js-Content`);
        });
}

class Project {
    constructor(obj) {
        this.id = obj.id
        this.client_id = obj.client_id
        this.business_id = obj.business_id
        this.title = obj.title
        // this.created_at = obj.created_at
        // this.updated_at = obj.updated_at
        this.status = obj.status
        this.comments = obj.comments
        this.time_entries = obj.time_entries
        // this.billable_hours = obj.billable_hours
        this.last_updated = obj.last_updated
        this.total_hours = obj.total_hours
    }
}

// return HTML entry for dashboard page
Project.prototype.projectsListHTML = function() {
    return (`
        <li class="list-group-item"><strong>Title:</strong> <a href="/projects/${this.id}" data-id="${this.id}">${this.title}</a> | <strong>Total Time:</strong> ${this.total_hours}  | <strong>Last Update:</strong> ${this.last_updated} | <strong>Status:</strong> ${this.formattedStatus()}</li>
    `)
}

// display a properly formatted status for the project
Project.prototype.formattedStatus = function() {
    const status = this.status
    return status.charAt(0).toUpperCase() + status.slice(1)    
}

Project.prototype.createComment = function() {
    const $form = $('form#new_comment');
    const action = $form.attr("action") + ".json";
    const params = $form.serialize();
    const currentProject = this;

    $.post(action, params)
        .done(function(json){
            //add to currentProjects comments property
            currentProject.comments.push(json.comment);

            const $ul = $("#comment-list");
            //clearing user submission from text area
            $("#comment_content").val("");
            //mimicking the rails list style
            $ul.prepend(`<li class="list-group-item"><strong>${json['user']['username']}</strong> says: ${json['comment']['content']} | <strong>Posted at:</strong> Just a moment ago... <a data-confirm="Are you sure?" class="js-DeleteComment btn-sm btn-danger pull-right buttonJS" rel="nofollow" data-method="delete" href="/comments/${json['comment']['id']}">X</a></li>`)
        }).fail(function(response){
            console.log("Something went wrong.", response);
        });
}

// Project.prototype.deleteComment = function() {

// }

Project.prototype.newTimeEntryForm = function() {
    $('.js-Content').load(`/projects/${this.id}/time_entries/new .js-Content`, () => {
        $('.clock').FlipClock();
    });
}

// Project.prototype.timeEntriesIndex = function() {
   
// }