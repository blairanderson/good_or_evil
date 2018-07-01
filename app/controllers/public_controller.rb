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

  def current_menus
    @menus ||= current_account.site_menus.where.not(location: SiteMenu.locations[:draft]).index_by(&:location)
  end

  def header_menu
    # enum location: {draft: 0, header: 1, footer: 2, sidebar: 3}
    current_menus[SiteMenu.locations[:header]]
  end
  helper_method :header_menu

  def footer_menu
    current_menus[SiteMenu.locations[:footer]]
  end

  helper_method :footer_menu

  def sidebar_menu
    current_menus[SiteMenu.locations[:sidebar]]
  end

  helper_method :sidebar_menu
end
