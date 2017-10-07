class AddSourceToItems < ActiveRecord::Migration
  def change
    add_column :items, :source, :text
    remove_column :list_items, :source
  end
end
