class User < ApplicationRecord
  attr_accessor :skip_password_req
  
  has_many :comments, dependent: :destroy
  has_many :time_entries, dependent: :nullify
  
  validates :username, presence: true
  validates :email, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :password, presence: true, unless: :skip_password_req
  validates :password_confirmation, presence: true, unless: :skip_password_req

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

  def full_name
    "#{self.first_name.upcase_first} #{self.last_name.upcase_first}"
  end
end
