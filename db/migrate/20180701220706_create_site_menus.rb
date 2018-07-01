class CreateSiteMenus < ActiveRecord::Migration
  def change
    create_table :site_menus do |t|
      t.references :account, index: true, foreign_key: true
      t.integer :location, default: 0
      t.timestamps null: false
    end
  end
end
