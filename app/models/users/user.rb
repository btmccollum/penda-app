class User < ApplicationRecord
  has_many :comments
  
  validates_presence_of :username
  validates_presence_of :email
  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_presence_of :password
  validates_presence_of :password_confirmation

  has_secure_password

  def self.generated_password
    Sysrandom.hex(32)
  end
end
