class User < ApplicationRecord
  attr_accessor :skip_password_req
  
  has_many :comments
  
  validates_presence_of :username
  validates_presence_of :email
  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_presence_of :password, unless: :skip_password_req
  validates_presence_of :password_confirmation, unless: :skip_password_req

  has_secure_password

  scope :locate_by_oauth, ->(auth) { where(provider: auth[:provider], uid: auth[:uid]).first }

  def self.create_from_oauth(auth)
    User.find_or_create_by(email: auth[:info][:email]) do |u|
      u.username = auth[:info][:email]
      u.email = auth[:info][:email]
      u.first_name = auth[:info][:name].split(" ").first
      u.last_name = auth[:info][:name].split(" ").last
      u.password = User.generated_password
      u.password_confirmation = u.password
      u.type = "Client"
      u.provider = auth[:provider]
      u.uid = auth[:uid]
      # u.image = auth['info']['image']
    end
  end

  def self.generated_password
    Sysrandom.hex(32)
  end
end
