module ApplicationHelper
  def nav_title
    ENV.fetch("NAV_TITLE")
  end

  def url_domain(uri)
    PublicSuffix.domain(uri).domain
  end

end
