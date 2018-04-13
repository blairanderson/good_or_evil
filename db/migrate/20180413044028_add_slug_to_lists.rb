class AddSlugToLists < ActiveRecord::Migration
  def change
    add_column(:lists, :slug, :string) unless column_exists?(:lists, :slug)
    add_index :lists, :slug
  end
end
