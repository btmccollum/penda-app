// # Place all the behaviors and hooks related to the matching controller here.
// # All this logic will automatically be available in application.js.
// # You can use CoffeeScript in this file: http://coffeescript.org/

class Comment {
    constructor(obj) {
        this.id = obj.id
        this.content = obj.content
        this.user_id = obj.user_id
        this.project_id = obj.project_id
        this.created_at = obj.created_at
        this.updated_at = obj.updated_at
        this.time_created = obj.time_created
    }
}
