class RemoveNameFromPages < ActiveRecord::Migration[7.0]
  def change
    remove_column :pages, :name, :string
  end
end
