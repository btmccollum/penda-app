class Business < User
    has_many :projects, dependent: :nullify
    has_many :clients, class_name: 'User', through: :projects, dependent: :nullify

    validates :username, uniqueness: true
    validates :email, uniqueness: true
end
