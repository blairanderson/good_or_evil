# this is for public account sites
# should be fast as possible with very good caching
# no authentication at all
class PublicController < ApplicationController
  before_filter :require_site
  def require_site
    @site = Account.friendly.find(request.subdomain)
    redirect_to root_path and return unless @site
  end

  def current_site
    @site ||= Account.friendly.find(request.subdomain)
  end

  helper_method :current_site
end
