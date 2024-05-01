class Province < ApplicationRecord
  has_many :customers

  def self.ransackable_associations(auth_object = nil)
    ["customers"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "gst", "hst", "id", "id_value", "name", "pst", "updated_at"]
  end

  # Note that gst, pst, and hst have to exist as 0 if there is no value for them.
  validates :name, uniqueness: true, presence: true, length: { minimum: 2 }
  validates :gst, :pst, :hst, numericality: { in: 0..1 }
end
