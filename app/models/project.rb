class Project < ApplicationRecord
    belongs_to :client, class_name: 'User', optional: true
    belongs_to :business, class_name: 'User', optional: true
    has_one :contract
    has_many :time_events
    has_many :comments

    validates :title, presence: true
    # validate :title_not_blank

    accepts_nested_attributes_for :client

    def last_updated
        self.updated_at.strftime("%A, %d %b %Y %l:%M %p")
    end

    def find_or_build_client_by(args)
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

    def add_form_errors
        self.errors.add(:title, "cannot be blank.") if self.title.blank?
        self.client.errors.add(:first_name, "cannot be blank.") if self.client.first_name.blank?
        self.client.errors.add(:last_name, "cannot be blank.") if self.client.last_name.blank?
        self.client.errors.add(:email, "cannot be blank.") if self.client.email.blank?
    end

    # def title_not_blank
    #     binding.pry
    #     if title.blank?
    #         errors.add(:title, "can't be blank.")
    #     end
    # end
end
