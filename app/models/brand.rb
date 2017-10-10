class Brand < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged
  has_many :items
  validates_presence_of :name, :slug
  validates_uniqueness_of :slug
end
