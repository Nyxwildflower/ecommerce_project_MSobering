class Product < ApplicationRecord
  has_and_belongs_to_many :categories
  has_many :order_items
  has_many :orders, through: :order_items

  # Define the attributes and associations that active admin can search.
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "description", "id", "id_value", "name", "on_sale", "price", "stock_quantity", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["categories", "order_items", "orders"]
  end

  validates :name, uniqueness: true
  validates :name, :description, presence: true, length: { minimum: 2 }
  validates :price, numericality: { greater_than_or_equal_to: 0.01 }
  validates :stock_quantity, numericality: { only_integer: true, greater_than: 0 }
  validates :on_sale, inclusion: [true, false]
end
