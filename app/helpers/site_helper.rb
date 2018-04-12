module SiteHelper
  def site_container_class_name
    return "" if controller_name == "brands" && action_name == "show"
    return "" if controller_name == "lists" && action_name == "show"
    "sans-serif"
  end

end
