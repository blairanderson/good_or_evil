class RemoveDetailsFromListItems < ActiveRecord::Migration
  def change
    remove_column(:list_items, :details)
  end
end
