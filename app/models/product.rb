class Product < ApplicationRecord
  has_and_belongs_to_many :categories
  has_many :order_items
  has_many :orders, through: :order_items

  validates :name, uniqueness: true
  validates :name, :description, presence: true, length: { minimum: 2 }
  validates :price, numericality: { greater_than: 0 }
  validates :stock_quantity, numericality: { only_integer: true, greater_than: 0 }
  validates :on_sale, inclusion: [true, false]
end
