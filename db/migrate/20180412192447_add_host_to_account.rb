class AddHostToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :host, :string
    add_column :accounts, :page_views, :integer, default: 0, null: false
    add_index :accounts, :host, unique: true, order: { page_views: "DESC NULLS LAST" }
  end
end
