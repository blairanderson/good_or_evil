class AddUserIdToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :user_id, :integer
    remove_column :users, :account_id

    Account.update_all(user_id: 1)

    change_column(:accounts, :user_id, :integer, null: false)
  end
end
