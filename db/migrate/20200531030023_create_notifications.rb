class CreateNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :notifications do |t|
      t.integer :visiter_id, presence: true
      t.integer :visited_id, presence: true
      t.integer :micropost_id
      t.integer :comment_id
      t.string :action
      t.boolean :checked, presence: true, default: false

      t.timestamps
    end
    add_index :notifications, :visiter_id
    add_index :notifications, :visited_id
  end
end
