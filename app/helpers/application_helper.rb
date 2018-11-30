module ApplicationHelper
    def has_permission? #authorization for business only
        current_user.class.name == "Business"
    end
end