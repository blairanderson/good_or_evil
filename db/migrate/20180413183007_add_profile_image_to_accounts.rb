class AddProfileImageToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :header_image_id, :string
    add_column :accounts, :header_image_filename, :string
    add_column :accounts, :header_image_content_size, :string
    add_column :accounts, :header_image_content_type, :string
  end
end
