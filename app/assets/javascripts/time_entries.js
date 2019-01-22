$(() => {
    attachListeners();
});

function attachListeners() {
    window.addEventListener("popstate", function(e) {
        if (window.historyInitiated) {
        window.location.reload();
        }
    });
}

class TimeEntry {
    constructor(obj) {
        this.id = obj.id
        this.title = obj.title
        this.content = obj.content
        this.user_id = obj.user_id
        this.project_id = obj.project_id
        this.start_time = obj.start_time
        this.end_time = obj.end_time
        this.duration = obj.duration
        this.total_time = obj.total_time
        this.finished = obj.finished
        this.created_at = obj.created_at
        this.updated_at = obj.updated_at
    }
}

TimeEntry.prototype.indexList = function() {
    return (`
        <li class="list-group-item"><strong>Title:</strong> <a href="/projects/${currentProject.id}/time_entries/${this.id}">${this.title}</a> | <strong>Duration:</strong> ${this.total_time} | <strong>Created:</strong> ${this.created_at}</li>
    `)
}