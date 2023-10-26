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

csv_file_path = Rails.root.join('db', 'data.csv')
count = 0
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

    product = Product.find_or_create_by(
        name: row['product_name'],
        description: row['description'],
        category: category,
        brand: brand,
        price: row['retail_price'],
        sale_price: row['discounted_price'],
        image: image
    )
end

AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?