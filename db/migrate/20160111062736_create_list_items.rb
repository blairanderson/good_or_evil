class CreateListItems < ActiveRecord::Migration
  def change
    create_table :list_items do |t|
      t.integer :list_id, null: false
      t.string :source, null: false
      t.integer :item_id
      t.text :details
      t.integer :sort, default: 0

      t.timestamps null: false
    end
    add_index :list_items, :list_id
    add_index :list_items, :item_id
    add_index :list_items, [:list_id, :item_id], unique: true
  end
end
