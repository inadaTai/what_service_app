class AddPictureToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :picture, :string
    add_column :users, :introduct, :text
  end
end
