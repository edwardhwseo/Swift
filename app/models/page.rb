class Page < ApplicationRecord
    validates :name, uniqueness: true, presence: true

    paginates_per 25
end
