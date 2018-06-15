class CreateListItemIngredients < ActiveRecord::Migration
  def change
    create_table :list_item_ingredients do |t|
      t.belongs_to :list_item, index: true, foreign_key: true
      t.string :name
      t.decimal :quantity, precision: 6, scale: 2
      t.integer :unit_cd
      t.string :comment


      t.timestamps null: false
    end
  end
end
