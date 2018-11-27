class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  has_many :comments
  
  validates_presence_of :username
  validates_presence_of :email
  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_presence_of :password
  validates_presence_of :password_confirmation

  validates_uniqueness_of :username
  validates_uniqueness_of :email

  def generated_password
    Devise.friendly_token.first(10)
  end
end
