class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :title
      t.string :asin
      t.integer :brand_id, index: true
      t.text :description
      t.integer :price_cents, default: 0, nil: false
      t.text :buy_now
      t.integer :total_offers, default: 0
      t.integer :sales_rank
      t.integer :page_views, default: 0
      t.text :dimensions
      t.text :package_dimensions
      t.text :buy_box
      t.text :images

      t.timestamps
    end
  end
end
