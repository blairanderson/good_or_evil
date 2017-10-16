class AddUserIdToListItems < ActiveRecord::Migration
  def change
    add_column :list_items, :user_id, :integer

    ListItem.update_all({
        user_id: List::BOOTSTRAP_USER_ID
      })

    change_column :list_items, :user_id, :integer, default: List::BOOTSTRAP_USER_ID
  end
end
