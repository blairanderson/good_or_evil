class AddRatingToListItems < ActiveRecord::Migration
  def change
    add_column :list_items, :rating, :integer
  end
end
