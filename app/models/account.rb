class Account < ActiveRecord::Base
  belongs_to :user
  has_many :lists
  validates_uniqueness_of :name, scope: [:user_id]
  extend FriendlyId
  friendly_id :name, use: :scoped, scope: [:user]


  # PUBLIC STUFF!
  def google_tag_manager
    nil
  end

  def lists_per_page
    25
  end

  def links
    []
  end

  def nav_title
    name
  end

  def header_subtitle
    nil
  end
end
