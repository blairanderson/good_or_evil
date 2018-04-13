class ListItem < ActiveRecord::Base
  belongs_to :list, counter_cache: :item_count
  belongs_to :user

  validates :affiliate_link, uniqueness: {scope: :list_id, message: "You already added this item!"}
end
