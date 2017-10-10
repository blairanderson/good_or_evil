class Brand < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged
  has_many :items
  scope :top_list, -> { where("items_count > 0").order("items_count DESC, slug ASC") }
  validates_presence_of :name, :slug
  validates_uniqueness_of :slug
end
