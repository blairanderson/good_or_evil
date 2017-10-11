class SavedItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :item
  validates_presence_of :item_id, :user_id
  validates_uniqueness_of :item_id, scope: [:user_id], message: "You already saved that item."
end
