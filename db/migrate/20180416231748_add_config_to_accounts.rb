class AddConfigToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :header_subtitle, :string
    add_column :accounts, :google_tag_manager, :string
    add_column :accounts, :about_page, :text
    add_column :accounts, :header_font, :integer, default: 0, null: false
    add_column :accounts, :header_subtitle_font, :integer, default: 0, null: false
    add_column :accounts, :list_header_font, :integer, default: 0, null: false
    add_column :accounts, :list_affiliate_disclosure, :text
  end
end
