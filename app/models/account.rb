class Account < ActiveRecord::Base
  belongs_to :user
  has_many :lists
  validates_uniqueness_of :name, scope: [:user_id]
  extend FriendlyId
  friendly_id :name, use: :scoped, scope: [:user]

  def google_tag_manager
    nil
  end

  def links
    []
  end

  def nav_title
    name
  end
end
