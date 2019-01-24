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
        // this.start_time = obj.start_time
        // this.end_time = obj.end_time
        this.duration = obj.duration
        this.total_time = obj.total_time
        this.finished = obj.finished
        // this.created_at = obj.created_at
        // this.updated_at = obj.updated_at
        this.start_time = obj.true_start_time
        this.end_time = obj.true_end_time
    }
}

TimeEntry.prototype.indexList = function() {
    return (`
        <li class="list-group-item"><strong>Title:</strong> <a href="/projects/${currentProject.id}/time_entries/${this.id}">${this.title}</a> | <strong>Duration:</strong> ${this.total_time} | <strong>Created:</strong> ${this.created_at}</li>
    `)
}

TimeEntry.prototype.timeCard = function() {
    return (`
        <div id="js-teCard">    
            <h1>Displaying Time Entry:</h1>

            <div class="row">
            <div class="col-lg-6 col-md-10 col-sm-10 col-12">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">Title: ${this.title}</h5>
                        <h6 class="card-subtitle mb-2 text-muted">Total Duration: ${this.duration}</h6>
                        <p class="card-text">Description: ${this.content}</p>
                        <p class="card-text">Start Time: ${this.true_start_time}</p>
                        <p class="card-text">End Time: ${this.true_end_time}</p> 
                    </div>
                </div>
            </div>
        </div>
        <br>

        <div class="js-teOptions">
            <p><a class="btn btn-secondary" href="/projects/${currentProject.id}">Back to Project</a></p>
        </div>
    `);
}