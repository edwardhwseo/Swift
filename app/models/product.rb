class Product < ApplicationRecord
  belongs_to :category
  belongs_to :brand

  paginates_per 25
end
