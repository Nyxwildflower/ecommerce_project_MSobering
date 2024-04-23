class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :name, presence: true, length: { minimum: 2 }
  validates :price, numericality: true
  validates :quantity, numericality: { only_integer: true, greater_than: 0 }
  validates :gst, :pst, :hst, numericality: { in: 0..1 }
end
