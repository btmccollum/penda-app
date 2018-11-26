class Client < User
    has_many :projects
    has_many :businesses, class_name: 'User', through: :projects
end
