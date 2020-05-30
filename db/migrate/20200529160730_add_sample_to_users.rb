class AddSampleToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :sample, :boolean, default: false
  end
end
