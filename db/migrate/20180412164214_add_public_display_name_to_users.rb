class AddPublicDisplayNameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :public_name, :string
  end
end
