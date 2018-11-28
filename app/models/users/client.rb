class Client < User
    has_many :projects
    has_many :businesses, class_name: 'User', through: :projects

    validates_uniqueness_of :username
    validates_uniqueness_of :email
end
