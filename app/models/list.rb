class List < ActiveRecord::Base
  belongs_to :category
  belongs_to :user
  has_many :list_items
  has_many :items, through: :list_items
  enum status: {draft: 0, published: 1, archived: 2, hidden: 3}
  enum display_theme: {grid: 0, story: 1}
  scope :sorted, -> { order("#{SORT_SOURCE} ASC, item_count DESC, sort ASC, page_views DESC") }
  scope :popular, -> { order("page_views DESC") }
  scope :visible, -> { where("item_count > 0").where("user_id = :bootstrap_user_id OR status = :published", bootstrap_user_id: BOOTSTRAP_USER_ID, published: List.statuses["published"]) }
  scope :for_sidebar, -> { distinct.select("lists.id, lists.name, lists.item_count").joins(:items).where("items.title IS NOT NULL").references(:items) }
  scope :bootstrap, -> { where(user_id: BOOTSTRAP_USER_ID).sorted }
  scope :amazon, -> { where("source LIKE '%amazon.com%'") }
  scope :wirecutter, -> { where("source LIKE '%wirecutter.com%'") }
  SORT_SOURCE = "case
    when source LIKE '%wirecutter.com%' THEN 1
    when source LIKE '%amazon.com%' THEN 2
    else 9999
  end"


  BOOTSTRAP_USER_ID = 0

  def to_param
    [
      id,
      (name.truncate(40) if name)
    ].compact.join("-").parameterize
  end

  validates :name, length: {minimum: 5}, allow_blank: true
  validates :body, length: {minimum: 30}, allow_blank: true

  with_options if: :published? do |published|
    published.validates :name, presence: {message: "Please create a title"}
    published.validates :body, presence: {message: "Please add a description"}
    # published.validates :category, presence: {message: "Please select a category"}
  end
end
