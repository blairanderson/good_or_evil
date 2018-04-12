class AddAccountIdToListsUsers < ActiveRecord::Migration
  def change
    add_column :lists, :account_id, :integer
    add_column :users, :account_id, :integer

    List.update_all(account_id: 1)
    User.update_all(account_id: 1)

    change_column :lists, :account_id, :integer, null: false
    change_column :users, :account_id, :integer, null: false
  end
end
