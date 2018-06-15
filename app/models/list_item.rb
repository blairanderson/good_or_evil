class ListItem < ActiveRecord::Base
  belongs_to :list, counter_cache: :item_count
  belongs_to :user
  has_many :list_item_ingredients
  attachment :image, type: :image

  as_enum :style, {
      product_link: 0,
      image_upload: 1,
      recipe_ingredients: 2,
      title_text: 5
    }

  # not smart enough to do this right now
  SORT_ENABLED = false

  def self.sorting_enabled?
    SORT_ENABLED
  end

  def form_title?
    true
  end

  def form_image?
    product_link? || image_upload?
  end

  def form_link?
    product_link?
  end

  def form_body?
    product_link? || title_text?
  end

  def form_ingredients?
    recipe_ingredients?
  end

  def sorting_enabled?
    SORT_ENABLED
  end

  # validates :affiliate_link, uniqueness: {scope: :list_id, message: "You already added this item!"}
  validates_inclusion_of(:style_cd, in: ListItem.styles.values)

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
