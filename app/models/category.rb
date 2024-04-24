class Category < ApplicationRecord
  has_and_belongs_to_many :products

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "id_value", "name", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["products"]
  end

  validates :name, presence: true, length: { minimum: 3 }, uniqueness: true
end
