# this is for public account sites
# should be fast as possible with very good caching
# no authentication at all
class PublicController < ApplicationController
  include RequireSite
  before_action :require_site

  def require_site
    redirect_to root_path and return unless current_account
  end

  def current_account
    @current_account ||= fetch_current_account
  end
  helper_method :current_account
end
