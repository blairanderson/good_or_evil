class Item < ActiveRecord::Base
  belongs_to :brand, counter_cache: :items_count
  has_many :list_items
  has_many :lists, through: :list_items
  serialize :dimensions, Hash
  serialize :package_dimensions, Hash
  serialize :buy_box, Hash
  serialize :images, Hash

  validates :title, length: {minimum: 5}, allow_blank: true
  validates :buy_now, url: true, allow_blank: true
  validates :source, format: {with: /amazon\.com/i, message: "Must be amazon.com"}, uniqueness: { case_sensitive: false }
  monetize :price_cents

  def sync!
    # SOME RATE LIMIT
    sleep(10)
    fetch = AmazonFetch.fetch(asin).with_indifferent_access
    new_state = fetch.slice(:title, :description, :buy_now, :total_offers, :sales_rank, :dimensions, :package_dimensions, :buy_box, :images)
    new_state[:price_cents] = new_state.dig(:buy_box, :winning, :Amount).to_i
    if fetch[:brand].to_s.length > 2 && brand = Brand.where(name: fetch[:brand]).first_or_create
      new_state[:brand_id] = brand.id
    end
    self.assign_attributes(new_state)
    self.save!
  end

  def self.sync!(limit: 10)
    Item.where(title: nil, price_cents: 0).where.not(asin: nil).limit(limit).each { |i| safely { i.sync! } }
  end

  def buy_now_url
    buy_now
  end

  def buy_now_domain
    host = URI.parse(buy_now).host.downcase
    host.start_with?('www.') ? host[4..-1] : host
  end

  def self.where_url(url)
    uri = URI(url)
    is_amazon = is_amazon?(uri.to_s)
    asin = parse_asin(url) if is_amazon
    source = if is_amazon && asin
               "#{uri.scheme}://#{uri.host}/dp/#{asin}/"
             elsif is_amazon
               "#{uri.scheme}://#{uri.host}/#{uri.path}"
             else
               uri.to_s
             end

    query = {source: source}
    query.merge!(asin: asin) if is_amazon && asin

    self.where(query)
  end

  def url=(url)
    @uri = URI(url)
    is_amazon = self.class.is_amazon?(@uri.to_s)
    self.asin = asin = self.class.parse_asin(url) if is_amazon
    self.source = if is_amazon && asin
                    "http://#{@uri.host}/dp/#{asin}/"
                  elsif is_amazon
                    "http://#{@uri.host}/#{@uri.path}"
                  else
                    @uri.to_s
                  end
  end

  def self.is_amazon?(uri)
    url && uri.to_s.include?("amazon.com/")
  end

  ASIN_REGEX = /\/(B[A-Z0-9]{9})/

  def self.parse_asin(uri)
    is_amazon?(uri) && uri.match(ASIN_REGEX).captures[0]
  end

  def source_domain
    PublicSuffix.parse(URI(source).host).domain
  end

  def url
    source
  end

end
