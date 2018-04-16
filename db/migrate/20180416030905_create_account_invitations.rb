class CreateAccountInvitations < ActiveRecord::Migration
  def change
    create_table :account_invitations do |t|
      t.references :user, index: true, foreign_key: true, null: false
      t.references :account, index: true, foreign_key: true, null: false
      t.string :email, null: false
      t.datetime :invitation_accepted_at

      t.timestamps null: false
    end

    add_index(:account_invitations, [:account_id, :email], unique: true)
  end
end
