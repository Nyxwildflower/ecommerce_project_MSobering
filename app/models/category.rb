class Category < ApplicationRecord
  has_and_belongs_to_many :products

  validates :name, presence: true, length: { minimum: 3 }, uniqueness: true
end
