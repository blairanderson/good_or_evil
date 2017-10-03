class AddSortToLists < ActiveRecord::Migration
  def change
    add_column :lists, :sort, :integer, default: 0
    add_column :lists, :page_views, :integer, default: 0
  end
end
