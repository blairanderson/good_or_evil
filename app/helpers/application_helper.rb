module ApplicationHelper
  def nav_title
    "Good_Or_Evil"
  end

  def url_domain(uri)
    PublicSuffix.domain(uri).domain
  end

  def container_class_name
    return "" if controller_name == "brands" && action_name == "show"
    return "" if controller_name == "lists" && action_name == "show"
    "container"
  end

  def feature(name)
    feature_cb(name, true)
  end

  def todo(name)
    feature_cb(name, false)
  end

  def feature_cb(name, checked)
    content_tag(:span, "#{check_box_tag(name.parameterize, 1, checked, readonly: "readonly", disabled: "disabled")} #{name}".html_safe)
  end

  def small_info(text)
    content_tag(:small, text.html_safe, class: "db pa3 bg-washed-blue br3 ba b--blue tc border-pulse")
  end

end
