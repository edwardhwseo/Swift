class Product < ApplicationRecord
  belongs_to :category
  belongs_to :brand
  has_many :order_items

  #has_one_attached :image

  paginates_per 25
end
