class User < ApplicationRecord
  has_many :comments
  
  validates_presence_of :username
  validates_presence_of :email
  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_presence_of :password
  validates_presence_of :password_confirmation

  has_secure_password

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
