// # Place all the behaviors and hooks related to the matching controller here.
// # All this logic will automatically be available in application.js.
// # You can use CoffeeScript in this file: http://coffeescript.org/
$(() => {
    addProjectListeners()
    defineCurrentProject()
});


function addProjectListeners() {
    $('body').on('click', 'a.js-Delete', function(e) {
        e.preventDefault();

        $(this).parent().fadeOut();
        
        $.post(this.href, "_method=delete");
        addProjectListeners();
        return false;
    });

    $('body').on('submit', '#new_comment', function(e) {
        if (currentProject !== undefined) {
            e.preventDefault();
            currentProject.createComment();
        }
    });

    $('body').on('click', '#new_project input.btn', () => {
        bindNewProject();
    });

    $('body').on('click', 'a.js-ShowTE', (e => {
        e.preventDefault();
        const data = e.target;
        currentProject.loadTimeEntry(data);
    }));

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

    $('body').on('click', '.js-NewProject', function(e) {
        e.preventDefault();
        loadNewProject();
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
    const path = window.location.pathname.match(/\w+/g);
    
    if (path === null) {
        return;
    }
    else if (path[0] === 'projects' && path[1] !== 'new') {
        const id = window.location.pathname.match(/\d+/g)[0];
        fetch(`/projects/${id}.json`)
            .then(response => response.json())
                .then(result => {
                    currentProject = new Project(result.project);
                });
    }
}

// sets push state when new pages are dynamically rendered
function setPushState(url) {
    window.historyInitiated = true;
    history.pushState(null, null, url);
}

function bindTimeEntryForm() {
    currentProject.newTimeEntryForm();
}

function bindAllTimeEntries() {
    currentProject.timeEntriesIndex();
}

function bindNewProject() {
    $('#new_project').submit(function(e) {
        e.preventDefault();
        newProject();
    });
}

function loadNewProject() {
    $('.js-Content').html("");
    $('.js-Content').load(`/projects/new #js-ProjectNewForm`);
    setPushState('/projects/new');
}

function newProject() {
    const $form = $('form#new_project');
    const action = $form.attr("action") + ".json";
    const params = $form.serialize();

    $.post(action, params)
        .done(function(json){
            currentProject = new Project(json['project']);

            $('.js-Content').html("");
            $('.js-Content').load(`/projects/${currentProject.id} .js-Content`);
            setPushState(`/projects/${currentProject.id}`);
        }).fail(function(response){
            console.log("Something went wrong.", response);
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
        this.comments = []
        this.time_entries = []
        // this.billable_hours = obj.billable_hours
        this.last_updated = obj.last_updated
        this.total_hours = obj.total_hours

        // instantiate collection of comment objects for use
        for(let c of obj.comments) {
            let comment = new Comment(c)
            this.comments.push(comment);
        }

        // instantiate collection of time entry objects for use
        for(let te of obj.time_entries) {
            let timeEntry = new TimeEntry(te)
            this.time_entries.push(timeEntry);
        }
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
   
    if (currentProject.time_entries[0] !== undefined) {
        currentProject.time_entries.forEach(function(te) {
            timeEntry = new TimeEntry(te);

            $('.js-TimeEntriesList').prepend(timeEntry.indexList());
        })
    } else {
        $('.js-TimeEntriesList').prepend('No recorded time entries. Click "Add New Entry" to get started.');
    }

    setPushState(`/projects/${currentProject.id}/time_entries`)
}

Project.prototype.loadTimeEntry = function(data) {
    const dataId = data.href.match(/\d+/g);
    const timeEntry = this.time_entries.find(te => {
        return te.id === parseInt(dataId[dataId.length - 1]);
    })
  
    $('.js-Content').html("");
    $('.js-Content').append(timeEntry.timeCard());

    if ( currentProject.client_id === timeEntry.user_id || this.business_id === timeEntry.user_id ) {
        $('.js-teOptions').prepend(`<p><a class="btn btn-secondary" href="/projects/${this.id}/time_entries/${timeEntry.id}/edit">Edit This Entry</a></p>`);
    }
    
    setPushState(`/projects/${this.id}/time_entries/${timeEntry.id}`);
}