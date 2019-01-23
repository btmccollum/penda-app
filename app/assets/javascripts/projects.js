// # Place all the behaviors and hooks related to the matching controller here.
// # All this logic will automatically be available in application.js.
// # You can use CoffeeScript in this file: http://coffeescript.org/
$(() => {
    addProjectListeners()
    defineCurrentProject()
});


function addProjectListeners() {
    // $('body').on('click', 'a.js-Delete', function (e) {
    //     e.preventDefault();
	// 	if (currentProject !== undefined) {
    //         currentProject.deleteComment(this);
    //     }
    // });
 
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

    // used to reset view when popstate is present from pushState() call, redefine currentproject when necessary
    window.addEventListener("popstate", function(e) {
        if (window.historyInitiated) {
          window.location.reload();
          defineCurrentProject();
        }
    });
}

let currentProject;

function defineCurrentProject() {
    path = window.location.pathname.match(/\w+/g);
    if (path[0] === 'projects') {
        const id = window.location.pathname.match(/\d+/g)[0];
        fetch(`/projects/${id}.json`)
            .then(response => response.json())
                .then(result => {
                    currentProject = new Project(result.project);
                });
    }
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

// Project.prototype.deleteComment = function(comment) {

//     let commentId = comment.dataset.id;
    // $.ajax({
    //     type: this.method,
    //     url: this.action + '/delete',
    //     data: $(this).serialize(),
    //     dataType: 'JSON'
    // })
    // debugger;
    // debugger;
    // fetch(`/comments/${commentId}`, {
    //     method: 'post',
    //     data: {
    //         action: 'delete'
    //     }
    //     })
    //     .then(response => response.json())
            // .then(data => {
            //     $('.js-Content').append(data)
            // })
            // debugger;
    // $.post(`/comments/${commentId}`, { type: 'POST', data: { _method: 'delete'}})
    // .done(() => {
    //     console.log('hi')
    // })
    // let newurl = 'https://localhost:3000/comments/' + commentId;
    // fetch(url, {
    //     method: "delete"
    // })
    // .then(
    //     response => response.json()).then(data => { console.log(data) }
    // )
    // $.ajax({
    //     url: `https://localhost:3000/comments/${commentId}`,
    //     method: 'DELETE',
    //     contentType: 'application/json',
    //     success: function(result) {
    //         $('.js-Content').html("");
    //         $('.js-Content').load(`/projects/${currentProject.id}.html .js-Content`);
    //     },
    //     error: function(request,msg,error) {
    //         // handle failure
    //         console.error(error);
    //     }
    // });
// }

Project.prototype.newTimeEntryForm = function() {
    $('.js-Content').load(`/projects/${this.id}/time_entries/new .js-Content`, () => {
        $('.clock').FlipClock();
    });
}

Project.prototype.timeEntriesIndex = function() {
    $('.js-Content').html("");
    $('.js-Content').html(`
        <h1>Displaying All Time Entries for ${currentProject.formattedTitle()}:</h1>

        <ul class="list-group js-TimeEntriesList">
        </ul>
    `);

    if (currentProject.time_entries !== undefined) {
        currentProject.time_entries.forEach(function(te) {
            timeEntry = new TimeEntry(te);

            $('.js-TimeEntriesList').prepend(timeEntry.indexList());
        })
    } else {
        $('.js-TimeEntriesList').prepend('No recorded time entries. Click "Add New Entry" to get started.');
    }

    //append project path to the URL history
    window.historyInitiated = true;
    history.pushState(null, null, `/projects/${currentProject.id}/time_entries`);
}