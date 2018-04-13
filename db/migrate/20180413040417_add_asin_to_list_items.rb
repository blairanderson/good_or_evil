class AddAsinToListItems < ActiveRecord::Migration
  def change
    add_column :list_items, :asin, :string
  end
end
