class Project < ApplicationRecord
    belongs_to :client, class_name: 'User', optional: true
    belongs_to :business, class_name: 'User', optional: true
    has_one :contract
    has_many :comments

    accepts_nested_attributes_for :client

    def last_updated
        self.updated_at.strftime("%A, %d %b %Y %l:%M %p")
    end

    def find_or_build_by(args)
        result = Client.find_by(email: args[:email])
        if result 
            self.client = result
        else
            self.build_client(args)
            self.client.type = "Client"
            self.client.username = project_client.email
            self.client.password = Client.generated_password
            self.client.password_confirmation = project_client.password
        end
    end
end
