class AddImageToListItem < ActiveRecord::Migration
  def change
    add_column :list_items, :image_id, :string
    add_column :list_items, :image_filename, :string
    add_column :list_items, :image_content_size, :string
    add_column :list_items, :image_content_type, :string
  end
end
