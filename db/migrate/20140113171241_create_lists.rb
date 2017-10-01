class CreateLists < ActiveRecord::Migration
  def change
    enable_extension :citext
    create_table :lists do |t|
      t.string :name
      t.text :body
      t.integer :status, default: 0
      t.integer :item_count, default: 0
      t.integer :display_theme, default: 0
      t.integer :category_id, index: true, nil: false
      t.integer :user_id, index: true, nil: false, default: 1
      t.timestamps
    end
  end
end
