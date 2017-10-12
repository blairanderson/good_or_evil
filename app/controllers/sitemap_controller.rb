class SitemapController < ActionController::Base
  include AbstractController::Rendering
  include ActionController::MimeResponds
  include ActionController::DataStreaming
  include ActionController::RackDelegation
  include ActionController::Rescue
  include ActionController::Head
  include ActionController::Redirecting
  include ActionController::ConditionalGet

  # Ensure ActiveSupport::Notifications events are fired
  include ActionController::Instrumentation

  # Sitemap cache time in seconds
  CACHE_TIME = 1.weeks
  CACHE_HEADER = "X-Sitemap-Cache"

  def robots
    respond_to :text
    expires_in 6.hours, public: true
  end

  def sitemap
    cache_hit = true
    default_host = "http://www.giftideaninja.com"
    force = Rails.env.development? || params[:force] == 'test'
    version = "1"
    key = "sitemap/#{version}"
    adapter = SitemapGenerator::NeverWriteAdapter.new

    sitemap = Rails.cache.fetch(key, expires_in: CACHE_TIME, force: force) do
      cache_hit = false

      open_lists = find_open_lists
      open_brands = find_open_brands

      SitemapGenerator::Sitemap.create(default_host: default_host, verbose: false, adapter: adapter) do
        open_brands.each do |record|
          add(record[:path], lastmod: record[:lastmod])
        end

        open_lists.each do |record|
          add(record[:path], lastmod: record[:lastmod])
        end
      end

      compressed = ActiveSupport::Gzip.compress(adapter.data)

      {
        content: compressed,
        digest: Digest::MD5.hexdigest(compressed),
        last_modified: Time.now
      }
    end

    headers[CACHE_HEADER] = cache_hit ? "1" : "0"
    expires_in(CACHE_TIME, public: true)

    # TODO figure out development version
    if Rails.env.development?
      render inline: CGI.escape_html(adapter.data) and return
    end

    if stale?(etag: sitemap[:digest], last_modified: sitemap[:last_modified])
      send_data(sitemap[:content], filename: "sitemap.xml.gz")
    end
  end

  def find_open_brands
    Brand.top_list
      .select("CONCAT('/brands/', brands.slug) AS path, brands.updated_at::timestamptz AS lastmod")
      .as_json.map(&:symbolize_keys)
  end

  # extract(epoch FROM your_datetime_column)
  def find_open_lists
    select_columns = "lists.id AS id, lists.name, lists.updated_at::timestamptz AS lastmod"
    List.visible.order("lastmod DESC").limit(max_sitemap_links)
      .select(select_columns).map do |list|
      {
        path: "/lists/#{list.to_param}",
        lastmod: list.lastmod
      }
    end
  end

  def max_sitemap_links
    SitemapGenerator::MAX_SITEMAP_LINKS
  end

end
