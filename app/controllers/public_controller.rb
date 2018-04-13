# this is for public account sites
# should be fast as possible with very good caching
# no authentication at all
class PublicController < ApplicationController
  before_filter :require_site

  def require_site
    redirect_to root_path and return unless current_account
  end

  OUR_DOMAINS = %w(aawbuilder.com lvh.me).freeze

  def current_account
    @site ||= if OUR_DOMAINS.any? { |d| request.host.to_s.include?(d) }
                Account.friendly.find(request.subdomain) rescue nil
              else
                Account.where(host: request.host).first
              end
  end
  helper_method :current_account
end
