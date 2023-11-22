# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

require 'csv'

Product.delete_all
Category.delete_all
Brand.delete_all
User.delete_all

csv_file_path = Rails.root.join('db', 'data.csv')
image_count = 0
discount_count = 0
price_count = 0
CSV.foreach(csv_file_path, headers: true) do |row|
    category = Category.find_or_create_by(
        name: row['product_category_tree'].split('>>')[0].tr('["%', '').strip()
    )
    brand = Brand.find_or_create_by(
        name: row['brand']
    )

    if row['image'] != nil
        image = row['image'].split(',')[0].tr('["', '')
    else
        image = row['image']
    end

    if row['retail_price'] == nil && row['discounted_price'] == nil
        price = 0
        discount = 0
    else
        price = row['retail_price']
        sale_price = row['discounted_price']
    end



    product = Product.find_or_create_by(
        name: row['product_name'],
        description: row['description'],
        category: category,
        brand: brand,
        price: price,
        sale_price: sale_price,
        image: image
    )
end

User.find_or_create_by(
    email: 'test@email.com',
    password_digest: '$2a$12$UhIQEXdq2Rpss/vhvn/IbuD0Fo1tBGsNI2gqLryEUY0f24T2JgPx2'
    first_name: 'first_name',
    last_name: 'last_name'
)

if AdminUser.count != 1
    AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?
end
