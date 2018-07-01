class AddPublishedAtToLists < ActiveRecord::Migration
  def change
    add_column :lists, :published_at, :datetime
  end
end
