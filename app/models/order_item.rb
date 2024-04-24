class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "gst", "hst", "id", "id_value", "name", "order_id", "price", "product_id", "pst", "quantity", "updated_at"]
  end

  validates :name, presence: true, length: { minimum: 2 }
  validates :price, numericality: { greater_than_or_equal_to: 0.01}
  validates :quantity, numericality: { only_integer: true, greater_than: 0 }
  validates :gst, :pst, :hst, numericality: { in: 0..1 }
end
