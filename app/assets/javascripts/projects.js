// # Place all the behaviors and hooks related to the matching controller here.
// # All this logic will automatically be available in application.js.
// # You can use CoffeeScript in this file: http://coffeescript.org/
$(() => {
    addListeners()
    defineCurrentProject()
});


function addListeners() {
    //make use of event delegation to capture link
    // $('.js-Projects').on('click', 'a', function(e) {
    //     e.preventDefault();
    //     loadProject(this);
    // }); 

	// $('a.js-AllProjects').on('click', function (e) {
    //     e.preventDefault();
	// 	getProjects();
    // });

    // $('a.js-ActiveProjects').on('click', function (e) {
    //     e.preventDefault();
    //     const params = { "status": "active" }
	// 	getProjects(params);
    // });

    // $('a.js-CompletedProjects').on('click', function (e) {
    //     e.preventDefault();
    //     params = { "status": "completed" }
	// 	getProjects(params);
    // });

    $('body').on('click', 'a.js-Delete', function (e) {
        console.log('got it')
        e.preventDefault();
		if (currentProject !== undefined) {
            currentProject.deleteComment(this);
        }
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

    // used to reset view when popstate is present from pushState() call
    window.addEventListener("popstate", function(e) {
        if (window.historyInitiated) {
          window.location.reload();
        }
    });
}

let currentProject;

function defineCurrentProject() {
    const id = window.location.pathname.match(/\d+/g)[0]
    fetch(`/projects/${id}.json`)
        .then(response => response.json())
            .then(result => {
                currentProject = new Project(result.project);
            });
}

// const currentProject = window.location.pathname.match(/\d+/g)[0]

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

function getProjects(query) {
    const url = new URL('https://localhost:3000/dashboard.json'), params = query;
    
    // append params to generated url if a query was made
    if (query !== undefined) {
        Object.keys(params).forEach(key => url.searchParams.append(key, params[key]));
    }

    fetch(url)
        .then(response => response.json())
            .then(data => {
                $('.js-Projects').html("");
                data['projects'].forEach(project => {
                    currentProject = new Project(project);
                    $('.js-Projects').prepend(currentProject.projectsListHTML());
                });
            });
}

function loadProject(data) {
    fetch(`/projects/${data.dataset.id}.json`)
        .then(response => response.json())
            .then(data => {
                currentProject = new Project(data.project);
                $('.js-Content').html("");
                $('.js-Content').load(`/projects/${currentProject.id}.html .js-Content`);

                //append project path to the URL history
                window.historyInitiated = true;
                history.pushState(null, null, `/projects/${currentProject.id}`);
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
        <li class="list-group-item"><strong>Title:</strong> <a href="/projects/${this.id}" data-id="${this.id}">${this.formattedTitle()}</a> | <strong>Total Time:</strong> ${this.total_hours}  | <strong>Last Update:</strong> ${this.last_updated} | <strong>Status:</strong> ${this.formattedStatus()}</li>
    `)
}

// display a properly formatted status for the project
Project.prototype.formattedStatus = function() {
    const status = this.status
    return status.charAt(0).toUpperCase() + status.slice(1)    
}

Project.prototype.formattedTitle = function() {
    const arr = this.title.split(" ");
    arr.forEach(function(word, index) {
        return arr[index] = word.charAt(0).toUpperCase() + word.slice(1);    
    });
    return arr.join(" ");
}

Project.prototype.createComment = function() {
    const $form = $('form#new_comment');
    const action = $form.attr("action") + ".json";
    const params = $form.serialize();
    const currentProject = this;

    $.post(action, params)
        .done(function(json){
            newComment = new Comment(json['comment'])
            currentProject.comments.push(newComment);

            const $ul = $("#comment-list");
            //clearing user submission from text area
            $("#comment_content").val("");
            //mimicking the rails list style
            $ul.prepend(`<li class="list-group-item"><strong>${json['user']['username']}</strong> says: ${newComment.content} | <strong>Posted at:</strong> Just a moment ago... <a data-id="${newComment.id}" data-confirm="Are you sure?" class="js-DeleteComment btn-sm btn-danger pull-right buttonJS" rel="nofollow" data-method="delete" href="/comments/${newComment.id}">X</a></li>`)
        }).fail(function(response){
            console.log("Something went wrong.", response);
        });
}

Project.prototype.deleteComment = function(comment) {
// debugger;
    const commentId = comment.dataset.id;

    fetch(`/comments/${commentId}`, {
        type: 'DELETE',
        body: JSON.stringify({id: commentId})
    }).then(function(response) {
        // debugger;
        console.log('removed!')
    })
}

Project.prototype.newTimeEntryForm = function() {
    $('.js-Content').load(`/projects/${this.id}/time_entries/new .js-Content`, () => {
        $('.clock').FlipClock();
    });
}

// Project.prototype.timeEntriesIndex = function() {
   
// }