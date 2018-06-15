class AddStyleCdToListItems < ActiveRecord::Migration
  def change
    add_column :list_items, :style_cd, :integer, default: 0
  end
end
