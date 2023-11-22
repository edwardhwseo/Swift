class AddAbbrToProvinces < ActiveRecord::Migration[7.0]
  def change
    add_column :provinces, :abbr, :string
  end
end
