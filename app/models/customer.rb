class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable, :validatable
  belongs_to :province
  has_many :orders

  validates :name, :email, :address, :username, presence: true
  validates :name, length: { minimum: 2 }
  validates :username, uniqueness: true, length: { minimum: 7 }
  validates :email, uniqueness: true, format: URI::MailTo::EMAIL_REGEXP
  validates :username, format: { with: /\A[a-zA-Z0-9]+\Z/ }
end
