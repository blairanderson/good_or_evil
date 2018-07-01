class CreateSiteMenuLinks < ActiveRecord::Migration
  def change
    create_table :site_menu_links do |t|
      t.references :site_menu, foreign_key: true
      t.integer :position, default: 0, null: false
      t.string :name, null: false
      t.string :link, null: false

      t.timestamps null: false
    end

    add_index(:site_menu_links, [:site_menu_id, :position], order: {position: :asc}, unique: true)
  end
end
