module RequireSite
  OUR_DOMAINS = %w(aawbuilder.com lvh.me).freeze
  def fetch_current_account
    if OUR_DOMAINS.any? { |d| request.host.to_s.include?(d) }
      Account.friendly.find(request.subdomain) rescue nil
    else
      Account.where(host: request.host).first
    end
  end
end
