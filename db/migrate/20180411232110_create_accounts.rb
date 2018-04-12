class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :name
      t.string :slug

      t.timestamps null: false
    end
  end
end
