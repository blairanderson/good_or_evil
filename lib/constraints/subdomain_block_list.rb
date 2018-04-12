class SubdomainBlockList
  RAILS_VERBS = %w(index show edit new create edit update destroy)
  AJAX_VERBS = %w(get patch post delete options)
  DOMAIN_NOUNS = %w(www admin accounts lists items saved carts office options settings admins)
  def self.matches?(request)
    subd = request.subdomain.to_s
    return false if subd.blank?
    return false if subd.in?(RAILS_VERBS)
    return false if subd.in?(AJAX_VERBS)
    return false if subd.in?(DOMAIN_NOUNS)
    true
  end

end
