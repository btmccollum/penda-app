class Business < User
    has_many :projects
    has_many :clients, class_name: 'User', through: :projects

    validates :username, uniqueness: true
    validates :email, uniqueness: true
end
