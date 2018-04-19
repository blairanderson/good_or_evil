class AddImageToLists < ActiveRecord::Migration
  def change
    add_column :lists, :image_id, :string
    add_column :lists, :image_filename, :string
    add_column :lists, :image_content_size, :string
    add_column :lists, :image_content_type, :string
  end
end
