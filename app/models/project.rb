class Project < ApplicationRecord
    belongs_to                      :client, class_name: 'User', optional: true
    belongs_to                      :business, class_name: 'User', optional: true
    has_one                         :contract
    has_many                        :time_entries, dependent: :destroy
    has_many                        :comments, dependent: :destroy

    validates                       :title, presence: true

    accepts_nested_attributes_for   :client

    scope                           :last_five, ->(p) { where(id: p.id).first.time_entries.order("updated_at DESC").limit(5) }
    scope                           :by_active, -> { where(status: "active") }
    scope                           :user_active, ->(user) { by_active.where(business_id: user.id).or(by_active.where(client_id: user.id)).order("updated_at DESC") }
    scope                           :by_completed, -> { where(status: "completed") }
    scope                           :user_completed, ->(user) { by_completed.where(business_id: user.id).or(by_completed.where(client_id: user.id)).order("updated_at DESC") }
    scope                           :search_by_title_and_user, lambda { |query, current_user| where("client_id IS ? OR business_id IS ?", current_user.id, current_user.id).where("title LIKE ?", "%#{query}%") }

    def last_updated
        self.updated_at.strftime("%A, %d %b %Y %l:%M %p")
    end

    def find_or_build_client_by(args) #necessary in nested form for client
        result = Client.find_by(email: args[:email])
        if result 
            self.client = result
            self.client.skip_password_req = true
        else
            self.build_client(args)
            self.client.type = "Client"
            self.client.username = args[:email]
            self.client.password = Client.generated_password
            self.client.password_confirmation = self.client.password
            self.client
        end
    end

    def add_form_errors #necessary in nested form for client
        self.errors.add(:title, "cannot be blank.") if self.title.blank?
        self.client.errors.add(:first_name, "cannot be blank.") if self.client.first_name.blank?
        self.client.errors.add(:last_name, "cannot be blank.") if self.client.last_name.blank?
        self.client.errors.add(:email, "cannot be blank.") if self.client.email.blank?
    end

    def billable_hours
        self.time_entries.sum("duration").to_f
    end

    # moved from projects helper to pass through project serializer
    def total_hours
        total = self.billable_hours

        if total >= 3600
            new_total = ((total / 60) / 60).round(2)
            "#{new_total} Hours"
        elsif total >= 60 && total < 3600
            new_total = (total / 60).round(2)
            "#{new_total} Minutes"
        else
            "#{total} Seconds"
        end
    end

    def self.active_projects(current_user)
        self.by_active.user_active(current_user)
    end

    def self.completed_projects(current_user)
        self.by_completed.user_completed(current_user)
    end
end
