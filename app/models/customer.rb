class Customer < ApplicationRecord
  belongs_to :province
  has_many :orders

  validates :name, :email, :address, :username, :hashed_password, :password_salt, presence: true
  validates :name, length: { minimum: 2 }
  validates :username, uniqueness: true, length: { minimum: 7 }
  validates :email, uniqueness: true, format: URI::MailTo::EMAIL_REGEXP
end
