class AddConfirmableToUsers < ActiveRecord::Migration
  def change

    ## Confirmable

    add_column :users, :confirmation_token, :string
    # t.string   :confirmation_token

    add_column :users, :confirmed_at, :datetime
    # t.datetime :confirmed_at

    add_column :users, :confirmation_sent_at, :datetime
    # t.datetime :confirmation_sent_at
    # t.string   :unconfirmed_email # Only if using reconfirmable

    ## Lockable
    add_column :users, :failed_attempts, :integer, default: 0, null: false
    # t.integer  :failed_attempts, :default => 0, :null => false # Only if lock strategy is :failed_attempts

    add_column :users, :unlock_token, :string
    # t.string   :unlock_token # Only if unlock strategy is :email or :both

    add_column :users, :locked_at, :datetime
    # t.datetime :locked_at
  end
end
