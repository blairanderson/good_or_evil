class ListItem < ActiveRecord::Base
  belongs_to :list, counter_cache: :item_count
  belongs_to :item

  validates_presence_of :source
  UNIQUE_MESSAGE = "You already added this item!"
  validates :item_id, uniqueness: {scope: :list_id,
      message: UNIQUE_MESSAGE}

  REGEX = /\/(B[A-Z0-9]{9})/

  def url=(uri)
    @uri = URI(uri)
    is_amazon = is_amazon?(@uri.to_s)
    asin = asin(uri)
    self.source = if is_amazon && asin
                    "#{@uri.scheme}://#{@uri.host}/dp/#{asin}/"
                  elsif is_amazon
                    "#{@uri.scheme}://#{@uri.host}/#{@uri.path}"
                  else
                    @uri.to_s
                  end
  end

  def is_amazon?(uri=source)
    URI(uri).host.include?("amazon.com")
  end

  def asin(uri=source)
    is_amazon?(uri) && URI(uri).path.match(REGEX).captures[0]
  end

  def source_domain
    PublicSuffix.parse(URI(source).host).domain
  end

  def url
    self.source
  end

end
