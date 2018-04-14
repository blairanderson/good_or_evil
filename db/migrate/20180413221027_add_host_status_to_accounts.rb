class AddHostStatusToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :domain_info, :json, default: {}
    add_column :accounts, :host_status, :integer
    add_column :accounts, :host_added_at, :datetime
    add_column :accounts, :host_confirmed_at, :datetime
  end
end
