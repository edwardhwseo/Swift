class RemoveContentFromPages < ActiveRecord::Migration[7.0]
  def change
    remove_column :pages, :content, :text
  end
end
