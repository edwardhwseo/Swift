class Province < ApplicationRecord
    validates :name, :abbr, uniqueness: true, presence: true
    validates :PST, presence: true
end
