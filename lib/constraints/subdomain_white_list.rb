class SubdomainWhiteList
  def self.matches?(request)
    # Rails.cache.fetch("Account.hosts", {namespace: :aawbuilder, race_condition_ttl: 10.seconds, expires_in: 30.seconds}) do
    #
    # end
    # matches a custom domain               matches a customer subdomain
    Account.hosts.has_key?(request.host) || Account.slugs.has_key?(request.subdomain)
  end
  RAILS_VERBS = %w(index show edit new create edit update destroy)
  AJAX_VERBS = %w(get patch post delete options)
  DOMAIN_NOUNS = %w(www admin accounts lists items saved carts office options settings admins)
end
