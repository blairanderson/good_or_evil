class Item < ActiveRecord::Base
  belongs_to :brand
  has_many :list_items
  has_many :lists, through: :list_items
  serialize :dimensions
  serialize :package_dimensions
  serialize :buy_box
  serialize :images

  validates_uniqueness_of :asin, allow_blank: true
  validates :title, presence: true, length: {minimum: 5}
  validates :buy_now, presence: true, url: true

  monetize :price_cents

  def buy_now_url
    buy_now
  end

  def buy_now_domain
    host = URI.parse(buy_now).host.downcase
    host.start_with?('www.') ? host[4..-1] : host
  end

end
