class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :validatable
  belongs_to :province
  has_many :orders

  validates :name, :email, :username, :address, presence: true
  validates :name, :address, length: { minimum: 2 }
  validates :username, uniqueness: true, length: { minimum: 7 }, format: { with: /\A[a-zA-Z0-9]+\Z/, message: "can only contain letters and numbers" }
  validates :email, uniqueness: true, format: URI::MailTo::EMAIL_REGEXP
end
