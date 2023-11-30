class Product < ApplicationRecord
  belongs_to :category
  belongs_to :brand
  has_many :order_items

  validates :name, uniqueness: true, presence: true
  validates :category_id, :brand_id, presence: true

  #has_one_attached :image

  paginates_per 25
end
