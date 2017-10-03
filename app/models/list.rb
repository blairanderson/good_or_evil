class List < ActiveRecord::Base
  belongs_to :category
  belongs_to :user
  has_many :list_items
  has_many :items, through: :list_items
  enum status: { draft: 0, published: 1, archived: 2, hidden: 3 }
  enum display_theme: { list: 0, carousel: 1 }

  BOOTSTRAP_USER_ID = 0

  def to_param
    [
      id,
      (name.truncate(40) if name)
    ].compact.join("-").parameterize
  end

  validates :name, length: { minimum: 10 }, allow_blank: true
  validates :body, length: { minimum: 30 }, allow_blank: true

  with_options if: :published? do |published|
    published.validates :name, presence: {message: "Please create a title"}
    published.validates :body, presence: {message: "Please add a description"}
    # published.validates :category, presence: {message: "Please select a category"}
  end
end
