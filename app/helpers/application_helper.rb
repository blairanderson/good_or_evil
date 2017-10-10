module ApplicationHelper
  def nav_title
    ENV.fetch("NAV_TITLE")
  end

  def url_domain(uri)
    PublicSuffix.domain(uri).domain
  end

  def container_class_name
    return "" if controller_name == "brands" && action_name == "show"
    return "" if controller_name == "lists" && action_name == "show"
    "container"
  end

end
