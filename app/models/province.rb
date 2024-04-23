class Province < ApplicationRecord
  has_many :customers

  # Note that gst, pst, and hst have to exist as 0 if there is no value for them.
  validates :name, uniqueness: true, presence: true, length: { minimum: 2 }
  validates :gst, :pst, :hst, numericality: { in: 0..1 }
end
