class CreateBrands < ActiveRecord::Migration
  def change
    create_table :brands do |t|
      t.citext :name
      t.string :slug

      t.timestamps
    end
  end
end
