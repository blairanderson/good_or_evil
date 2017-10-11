class CreateSavedItems < ActiveRecord::Migration
  def change
    create_table :saved_items do |t|
      t.integer :item_id
      t.integer :user_id

      t.timestamps null: false
    end

    add_index :saved_items, [:item_id, :user_id], unique: true
  end
end
