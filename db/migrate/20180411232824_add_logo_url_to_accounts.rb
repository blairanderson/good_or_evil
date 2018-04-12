class AddLogoUrlToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :lazy_logo_url, :string
  end
end
