class AddSourceToLists < ActiveRecord::Migration
  def change
    add_column :lists, :source, :string
  end
end
