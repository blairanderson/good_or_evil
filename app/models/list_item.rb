class ListItem < ActiveRecord::Base
  belongs_to :list, counter_cache: :item_count
  belongs_to :item
  belongs_to :user

  UNIQUE_MESSAGE = "You already added this item!"
  validates :item_id, uniqueness: {scope: :list_id,
      message: UNIQUE_MESSAGE}

end
