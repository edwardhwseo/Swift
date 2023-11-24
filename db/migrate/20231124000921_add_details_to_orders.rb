class AddDetailsToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :tax, :float
    add_column :orders, :total, :float
  end
end
