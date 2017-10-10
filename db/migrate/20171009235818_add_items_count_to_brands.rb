class AddItemsCountToBrands < ActiveRecord::Migration
  def change
    add_column :brands, :items_count, :integer, default: 0
    add_index :brands, :slug, unique: true
  end
end
