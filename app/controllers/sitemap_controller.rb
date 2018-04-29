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

  def current_account
    @current_account ||= begin
      Account.find(Account.hosts[request.host] || Account.slugs[request.subdomain])
    end
  end

  def account_route_params
    current_account.host ? {host: current_account.host} : {subdomain: current_account.slug}
  end

  helper_method :current_account, :account_route_params

  def robots
    respond_to :text
    expires_in 6.hours, public: true
  end

  def sitemap
    cache_hit = true
    default_host = root_url(account_route_params)
    force = Rails.env.development? || params[:force] == 'test'
    version = "1"
    key = ["sitemap/#{version}", current_account.updated_at]
    adapter = SitemapGenerator::NeverWriteAdapter.new

    sitemap = Rails.cache.fetch(key, expires_in: CACHE_TIME, force: force) do
      cache_hit = false

      open_lists = find_open_lists

      SitemapGenerator::Sitemap.create(default_host: default_host, verbose: false, adapter: adapter) do
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
    select_columns = "lists.id AS id, CONCAT('/',lists.slug) AS slug, lists.updated_at::timestamptz AS lastmod"
    current_account.lists.select(select_columns).visible.order("lastmod DESC").limit(max_sitemap_links).map do |list|
      {
        path: list.slug,
        lastmod: list.lastmod
      }
    end
  end

  def max_sitemap_links
    SitemapGenerator::MAX_SITEMAP_LINKS
  end

end
