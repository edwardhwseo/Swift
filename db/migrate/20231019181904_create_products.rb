class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :name
      t.references :category, null: false, foreign_key: true
      t.references :brand, null: false, foreign_key: true
      t.text :description
      t.float :price
      t.float :sale_price
      t.string :image

      t.timestamps
    end
  end
end
