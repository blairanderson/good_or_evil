class List < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :scoped, scope: [:account]
  BOOTSTRAP_USER_ID = 0
  belongs_to :category
  belongs_to :account
  belongs_to :user
  has_many :list_items
  enum status: {drafts: 0, published: 1, archived: 2, hidden: 3}
  enum display_theme: {grid: 0, story: 1}
  scope :sorted, -> { order("#{SORT_SOURCE} ASC, item_count DESC, sort ASC, page_views DESC") }
  scope :popular, -> { order("page_views DESC") }
  scope :visible, -> { where("status = :published", published: List.statuses["published"]) }
  scope :for_sidebar, -> { distinct.select("lists.name, lists.slug") }
  scope :bootstrap, -> { where(user_id: BOOTSTRAP_USER_ID).sorted }
  scope :amazon, -> { where("source LIKE '%amazon.com%'") }
  scope :wirecutter, -> { where("source LIKE '%wirecutter.com%'") }
  SORT_SOURCE = "CASE
    WHEN source LIKE '%wirecutter.com%' THEN 1
    WHEN source LIKE '%amazon.com%' THEN 2
    ELSE 9999
  END"

  def image
    "//mrmrs.github.io/photos/cpu.jpg"
  end

  def word_count
    ActionController::Base.helpers.strip_tags(body).to_s.scan(/[\w-]+/).size
  end

  validates :name, length: {minimum: 5}, allow_blank: true
  validates :body, length: {minimum: 30}, allow_blank: true

  with_options if: :published? do |published|
    published.validates :name, presence: {message: "Please create a title"}
    published.validates :body, presence: {message: "Please add a description"}
    # published.validates :category, presence: {message: "Please select a category"}
  end
end
