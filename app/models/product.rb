class Product < ApplicationRecord
  has_one_attached :image do |attachable|
    attachable.variant :admin_display, resize_to_limit: [100, 200], quality: 100
    attachable.variant :small_display, resize_and_pad: [400, 400, background: [255, 255, 255]], quality: 100
  end

  has_and_belongs_to_many :categories
  accepts_nested_attributes_for :categories, :image_attachment, :image_blob, allow_destroy: true
  has_many :order_items
  has_many :orders, through: :order_items

  # Define the attributes and associations that active admin can search.
  def self.ransackable_attributes(auth_object = nil)
    ["image_record_id", "image_blob_id", "description", "id", "id_value", "name", "on_sale", "price", "stock_quantity", "created_at", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["image_attachment", "image_blob", "categories", "order_items", "orders"]
  end

  validates :name, uniqueness: true
  validates :name, :description, presence: true, length: { minimum: 2 }
  validates :price, numericality: { greater_than_or_equal_to: 0.01 }
  validates :stock_quantity, numericality: { only_integer: true, greater_than: 0 }
  validates :on_sale, inclusion: [true, false]
end
