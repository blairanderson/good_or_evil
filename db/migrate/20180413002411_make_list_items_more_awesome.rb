class MakeListItemsMoreAwesome < ActiveRecord::Migration
  def change
    add_column :list_items, :body, :text
    add_column :list_items, :affiliate_link, :text
    add_column :list_items, :click_count, :integer, default: 0

    change_column :list_items, :sort, :integer, null: false, default: 0

    remove_column :list_items, :item_id
  end
end
