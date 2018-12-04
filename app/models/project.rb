class Project < ApplicationRecord
    belongs_to :client, class_name: 'User', optional: true
    belongs_to :business, class_name: 'User', optional: true
    has_one :contract
    has_many :time_entries
    has_many :comments

    validates :title, presence: true

    accepts_nested_attributes_for :client

    #find last 5 time entries for a given project
    scope :last_five, ->(p) { where(id: p.id).first.time_entries.order("created_at DESC").limit(5) }

    def last_updated
        self.updated_at.strftime("%A, %d %b %Y %l:%M %p")
    end

    def find_or_build_client_by(args) #necessary in nested form for client
        result = Client.find_by(email: args[:email])
        if result 
            self.client = result
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
end
