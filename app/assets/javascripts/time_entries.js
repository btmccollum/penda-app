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