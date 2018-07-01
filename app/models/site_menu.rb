class SiteMenu < ActiveRecord::Base
  belongs_to :account
  has_many :site_menu_links
  enum location: {draft: 0, header: 1, footer: 2, sidebar: 3}
end
