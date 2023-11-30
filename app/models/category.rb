class Category < ApplicationRecord
    has_many :products

    validates :name, uniqueness: true, presence: true

    paginates_per 25
end
