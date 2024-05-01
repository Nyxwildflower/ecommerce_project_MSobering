class Order < ApplicationRecord
  belongs_to :customer
  has_many :order_items
  has_many :products, through: :order_items

  def self.ransackable_associations(auth_object = nil)
    ["customer", "order_items", "products"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "customer_id", "id", "id_value", "total_price", "updated_at"]
  end

  validates :total_price, presence: true, numericality: { greater_than_or_equal_to: 0.01 }
end
