class User < ApplicationRecord
    has_secure_password
    belongs_to :province
    validates :email, uniqueness: true, presence: true
    validates :first_name, :last_name, :password_digest, :province_id, presence: true
end
