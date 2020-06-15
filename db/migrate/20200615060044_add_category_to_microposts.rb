class AddCategoryToMicroposts < ActiveRecord::Migration[6.0]
  def change
    add_column :microposts, :category, :string
  end
end
