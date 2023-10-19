# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

require 'csv'

csv_file_path = Rails.root.join('db', 'data.csv')
csv = CSV.read(csv_file_path, headers: true)

print(csv[0]['product_category_tree'].split('>>')[0].tr('["%', '').strip())