class ListItem < ActiveRecord::Base
  belongs_to :list, counter_cache: :item_count
  belongs_to :user
  attachment :image, type: :image

  # not smart enough to do this right now
  SORT_ENABLED = false

  def self.sorting_enabled?
    SORT_ENABLED
  end

  def sorting_enabled?
    SORT_ENABLED
  end

  validates :affiliate_link, uniqueness: {scope: :list_id, message: "You already added this item!"}
  validates_presence_of(:title, :affiliate_link)

  def amazon?
    affiliate_link.to_s.include?("amazon.com")
  end

  def fetch_asin
    amazon? && Regexp.new("/([a-zA-Z0-9]{10})(?:[/?]|$)").match(affiliate_link).to_a[1]
  end

  def asin_image(asin)
    "http://images.amazon.com/images/P/#{asin}.01.LZ.jpg"
  end
end
